package org.citra.citra_emu.channel

import io.flutter.plugin.common.EventChannel
import org.citra.citra_emu.utils.DiskShaderCacheProgress

class ShaderProgressStreamHandler : EventChannel.StreamHandler {
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        DiskShaderCacheProgress.listener =
            DiskShaderCacheProgress.Listener { stage, progress, max ->
                events.success(mapOf("stage" to stage.name, "progress" to progress, "max" to max))
            }
    }

    override fun onCancel(arguments: Any?) {
        DiskShaderCacheProgress.listener = null
    }
}
