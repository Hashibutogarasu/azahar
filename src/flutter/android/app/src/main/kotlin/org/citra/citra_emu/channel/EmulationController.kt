package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import org.citra.citra_emu.NativeLibrary

class EmulationController(private val textureRegistry: TextureRegistry) {
    private var surfaceProducer: TextureRegistry.SurfaceProducer? = null
    private var secondarySurfaceProducer: TextureRegistry.SurfaceProducer? = null
    private var screensSwapped = false

    val handlers: List<AzaharMethodHandler> = listOf(
        CreateEmulationTexture(),
        StartEmulation(),
        PauseEmulation(),
        ResumeEmulation(),
        SwapScreens(),
        StopEmulation()
    )

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
            Thread { NativeLibrary.run(path) }.start()
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
}
