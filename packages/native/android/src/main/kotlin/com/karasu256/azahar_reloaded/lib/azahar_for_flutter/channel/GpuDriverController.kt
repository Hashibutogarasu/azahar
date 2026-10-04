package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.GpuDriverHelper
import java.io.File

class GpuDriverController {
    val handlers: List<AzaharMethodHandler> = listOf(
        SupportsCustomDriverLoading(),
        ListGpuDrivers(),
        GetSelectedGpuDriver(),
        InstallGpuDriver(),
        SelectGpuDriver()
    )

    private inner class SupportsCustomDriverLoading : AzaharMethodHandler {
        override val name = "supportsCustomDriverLoading"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(GpuDriverHelper.supportsCustomDriverLoading())
        }
    }

    private inner class ListGpuDrivers : AzaharMethodHandler {
        override val name = "listGpuDrivers"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val drivers = GpuDriverHelper.getDrivers().map { (uri, metadata) ->
                mapOf(
                    "uri" to uri.toString(),
                    "name" to metadata.name,
                    "description" to metadata.description,
                    "author" to metadata.author,
                    "vendor" to metadata.vendor,
                    "version" to metadata.version
                )
            }
            result.success(drivers)
        }
    }

    private inner class GetSelectedGpuDriver : AzaharMethodHandler {
        override val name = "getSelectedGpuDriver"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(GpuDriverHelper.customDriverData.name)
        }
    }

    private inner class InstallGpuDriver : AzaharMethodHandler {
        override val name = "installGpuDriver"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")!!
            val copied = GpuDriverHelper.copyDriverToExternalStorage(Uri.fromFile(File(path)))
            result.success(copied != null)
        }
    }

    private inner class SelectGpuDriver : AzaharMethodHandler {
        override val name = "selectGpuDriver"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val uri = call.argument<String>("uri")
            val success = if (uri.isNullOrEmpty()) {
                GpuDriverHelper.installDefaultDriver()
                true
            } else {
                GpuDriverHelper.installCustomDriverComplete(Uri.parse(uri))
            }
            result.success(success)
        }
    }
}
