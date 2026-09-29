package org.citra.citra_emu.channel

import io.flutter.plugin.common.EventChannel
import org.citra.citra_emu.utils.LogLineRelay

/**
 * Streams batches of native log lines to Dart, which decides where they are stored.
 */
class LogStreamHandler : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        LogLineRelay.setListener { lines -> events.success(lines) }
    }

    override fun onCancel(arguments: Any?) {
        LogLineRelay.setListener(null)
    }
}
