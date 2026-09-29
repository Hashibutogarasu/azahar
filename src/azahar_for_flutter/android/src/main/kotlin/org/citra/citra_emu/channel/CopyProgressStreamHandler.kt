package org.citra.citra_emu.channel

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
