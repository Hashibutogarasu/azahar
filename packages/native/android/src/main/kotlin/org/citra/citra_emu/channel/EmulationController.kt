package org.citra.citra_emu.channel

import android.os.Handler
import android.os.Looper
import android.view.Choreographer
import androidx.preference.PreferenceManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary
import java.util.concurrent.CountDownLatch

class EmulationController(private val textureRegistry: TextureRegistry) {
    init {
        current = this
    }

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
        AdvanceFrame(),
        PauseRendering(),
        ResumeRendering(),
        SwapScreens(),
        TouchEvent(),
        TouchMoved()
    )

    private val isTouchEnabled: Boolean
        get() = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
            .getBoolean("isTouchEnabled", true)

    /**
     * Creates a screen texture for a session owned by the native side and hands its surface to the
     * emulation. Blocks the calling thread until the platform thread has created it.
     *
     * @return The id of the texture, or -1 when it could not be created.
     */
    fun createSessionTexture(width: Int, height: Int, secondary: Boolean): Long {
        return runOnPlatformThread(-1L) {
            screensSwapped = false
            val producer = textureRegistry.createSurfaceProducer()
            producer.setSize(width, height)
            if (secondary) {
                secondarySurfaceProducer?.release()
                secondarySurfaceProducer = producer
                NativeLibrary.surfaceChangedSecondary(producer.surface)
            } else {
                surfaceProducer?.release()
                surfaceProducer = producer
                NativeLibrary.surfaceChanged(producer.surface)
            }
            startPresentingFrames()
            producer.id()
        }
    }

    /**
     * Detaches and releases the textures created by [createSessionTexture]. Blocks the calling
     * thread until the platform thread has released them.
     */
    fun releaseSessionTextures() {
        runOnPlatformThread(Unit) {
            stopPresentingFrames()
            NativeLibrary.surfaceDestroyed()
            NativeLibrary.surfaceDestroyedSecondary()
            surfaceProducer?.release()
            surfaceProducer = null
            secondarySurfaceProducer?.release()
            secondarySurfaceProducer = null
        }
    }

    private fun <T> runOnPlatformThread(fallback: T, block: () -> T): T {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            return block()
        }
        var result = fallback
        val done = CountDownLatch(1)
        Handler(Looper.getMainLooper()).post {
            try {
                result = block()
            } finally {
                done.countDown()
            }
        }
        done.await()
        return result
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

    companion object {
        /**
         * The controller bound to the engine of this process, used by the native side to create
         * the screen textures of a session.
         */
        @Volatile
        var current: EmulationController? = null
            private set
    }
}
