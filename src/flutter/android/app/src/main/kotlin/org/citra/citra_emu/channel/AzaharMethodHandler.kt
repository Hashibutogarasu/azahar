package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface AzaharMethodHandler {
    val name: String
    fun execute(call: MethodCall, result: MethodChannel.Result)
}
