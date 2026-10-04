package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface AzaharMethodHandler {
    val name: String
    fun execute(call: MethodCall, result: MethodChannel.Result)
}
