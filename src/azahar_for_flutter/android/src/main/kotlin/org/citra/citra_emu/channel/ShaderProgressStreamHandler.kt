package org.citra.citra_emu.channel

import io.flutter.plugin.common.EventChannel
import org.citra.citra_emu.utils.DiskShaderCacheProgress

class ShaderProgressStreamHandler : EventChannel.StreamHandler {
    private var installedListener: DiskShaderCacheProgress.Listener? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val listener = DiskShaderCacheProgress.Listener { stage, progress, max ->
            events.success(mapOf("stage" to stage.name, "progress" to progress, "max" to max))
        }
        installedListener = listener
        DiskShaderCacheProgress.listener = listener
    }

    override fun onCancel(arguments: Any?) {
        if (DiskShaderCacheProgress.listener === installedListener) {
            DiskShaderCacheProgress.listener = null
        }
        installedListener = null
    }
}
