package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.applets.MiiSelector

class ShowMiiSelector(private val appletChannel: MethodChannel) {
    val name = "showMiiSelector"

    fun execute(
        config: MiiSelector.MiiSelectorConfig,
        callback: (returnCode: Long, index: Int) -> Unit
    ) {
        appletChannel.invokeMethod(
            name,
            mapOf(
                "title" to config.title,
                "enableCancelButton" to config.enableCancelButton,
                "miiNames" to config.miiNames.toList()
            ),
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    val map = (result as Map<*, *>)
                    callback(
                        (map["returnCode"] as Number).toLong(),
                        (map["index"] as Number).toInt()
                    )
                }

                override fun error(code: String, message: String?, details: Any?) {
                    callback(1, 0)
                }

                override fun notImplemented() {
                    callback(1, 0)
                }
            }
        )
    }
}
