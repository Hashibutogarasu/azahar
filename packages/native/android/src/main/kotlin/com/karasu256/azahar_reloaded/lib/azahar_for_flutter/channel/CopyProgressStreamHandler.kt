// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.EventChannel

class CopyProgressStreamHandler(
    private val directoryController: DirectoryController
) : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        directoryController.copyProgressSink = events
    }

    override fun onCancel(arguments: Any?) {
        directoryController.copyProgressSink = null
    }
}
