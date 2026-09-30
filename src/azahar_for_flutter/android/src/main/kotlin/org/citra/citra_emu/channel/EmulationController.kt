package org.citra.citra_emu.channel

import android.view.Choreographer
import androidx.preference.PreferenceManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary

class EmulationController(private val textureRegistry: TextureRegistry) {
    private var surfaceProducer: TextureRegistry.SurfaceProducer? = null
    private var secondarySurfaceProducer: TextureRegistry.SurfaceProducer? = null
    private var screensSwapped = false

    private val frameCallback = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            Choreographer.getInstance().postFrameCallback(this)
            NativeLibrary.doFrame()
            NativeLibrary.doFrameSecondary()
        }
    }
    private var isPresentingFrames = false

    private fun startPresentingFrames() {
        if (isPresentingFrames) return
        isPresentingFrames = true
        Choreographer.getInstance().postFrameCallback(frameCallback)
    }

    private fun stopPresentingFrames() {
        if (!isPresentingFrames) return
        isPresentingFrames = false
        Choreographer.getInstance().removeFrameCallback(frameCallback)
    }

    val handlers: List<AzaharMethodHandler> = listOf(
        CreateEmulationTexture(),
        StartEmulation(),
        PauseEmulation(),
        ResumeEmulation(),
        AdvanceFrame(),
        PauseRendering(),
        ResumeRendering(),
        SwapScreens(),
        StopEmulation(),
        TouchEvent(),
        TouchMoved()
    )

    private val isTouchEnabled: Boolean
        get() = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean("isTouchEnabled", true)

    private inner class CreateEmulationTexture : AzaharMethodHandler {
        override val name = "createEmulationTexture"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val width = call.argument<Int>("width") ?: 1
            val height = call.argument<Int>("height") ?: 1
            val secondary = call.argument<Boolean>("secondary") ?: false
            val producer = textureRegistry.createSurfaceProducer()
            producer.setSize(width, height)
            if (secondary) {
                secondarySurfaceProducer?.release()
                secondarySurfaceProducer = producer
            } else {
                surfaceProducer?.release()
                surfaceProducer = producer
            }
            result.success(producer.id().toInt())
        }
    }

    private inner class StartEmulation : AzaharMethodHandler {
        override val name = "startEmulation"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")
            if (path == null) {
                result.error("invalid_argument", "path is required", null)
                return
            }
            surfaceProducer?.let { NativeLibrary.surfaceChanged(it.surface) }
            secondarySurfaceProducer?.let { NativeLibrary.surfaceChangedSecondary(it.surface) }
            if (NativeLibrary.isRunning()) {
                NativeLibrary.unPauseEmulation()
            } else {
                Thread { NativeLibrary.run(path) }.start()
            }
            startPresentingFrames()
            result.success(null)
        }
    }

    private inner class PauseEmulation : AzaharMethodHandler {
        override val name = "pauseEmulation"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            NativeLibrary.pauseEmulation()
            result.success(null)
        }
    }

    private inner class ResumeEmulation : AzaharMethodHandler {
        override val name = "resumeEmulation"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            NativeLibrary.unPauseEmulation()
            result.success(null)
        }
    }

    private inner class AdvanceFrame : AzaharMethodHandler {
        override val name = "advanceFrame"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            NativeLibrary.advanceFrame()
            result.success(null)
        }
    }

    private inner class PauseRendering : AzaharMethodHandler {
        override val name = "pauseRendering"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            stopPresentingFrames()
            result.success(null)
        }
    }

    private inner class ResumeRendering : AzaharMethodHandler {
        override val name = "resumeRendering"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            startPresentingFrames()
            result.success(null)
        }
    }

    private inner class SwapScreens : AzaharMethodHandler {
        override val name = "swapScreens"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            screensSwapped = !screensSwapped
            NativeLibrary.swapScreens(screensSwapped, 0)
            result.success(screensSwapped)
        }
    }

    private inner class StopEmulation : AzaharMethodHandler {
        override val name = "stopEmulation"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            stopPresentingFrames()
            NativeLibrary.stopEmulation()
            NativeLibrary.surfaceDestroyed()
            NativeLibrary.surfaceDestroyedSecondary()
            surfaceProducer?.release()
            surfaceProducer = null
            secondarySurfaceProducer?.release()
            secondarySurfaceProducer = null
            result.success(null)
        }
    }

    private inner class TouchEvent : AzaharMethodHandler {
        override val name = "onTouchEvent"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            if (!isTouchEnabled) {
                result.success(false)
                return
            }
            val x = call.argument<Double>("x") ?: 0.0
            val y = call.argument<Double>("y") ?: 0.0
            val pressed = call.argument<Boolean>("pressed") ?: false
            result.success(NativeLibrary.onTouchEvent(x.toFloat(), y.toFloat(), pressed))
        }
    }

    private inner class TouchMoved : AzaharMethodHandler {
        override val name = "onTouchMoved"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            if (isTouchEnabled) {
                val x = call.argument<Double>("x") ?: 0.0
                val y = call.argument<Double>("y") ?: 0.0
                NativeLibrary.onTouchMoved(x.toFloat(), y.toFloat())
            }
            result.success(null)
        }
    }
}
