package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.NativeLibrary

/**
 * A single Wi-Fi access point, typed to match Flutter's `AccessPoint` freezed model, so the
 * "bssid|rssi|channel|security|ssid" wire format used by [NativeLibrary.scanWifiAccessPoints] is
 * parsed/formatted in one place instead of being handled as loose strings at each call site.
 */
private data class WifiAccessPointEntry(
    val ssid: String,
    val bssid: String,
    val frequency: Int,
    val level: Int
) {
    fun toChannelMap(): Map<String, Any?> {
        return mapOf("ssid" to ssid, "bssid" to bssid, "frequency" to frequency, "level" to level)
    }

    fun toWireEntry(): String {
        return "$bssid|$level|${WifiController.frequencyToChannel(frequency)}|0|$ssid"
    }

    companion object {
        fun fromWireEntry(entry: String): WifiAccessPointEntry? {
            val parts = entry.split("|", limit = 5)
            if (parts.size != 5) return null
            val level = parts[1].toIntOrNull() ?: return null
            val channel = parts[2].toIntOrNull() ?: return null
            return WifiAccessPointEntry(
                ssid = parts[4],
                bssid = parts[0],
                frequency = WifiController.channelToFrequency(channel),
                level = level
            )
        }

        fun fromChannelMap(map: Map<String, Any?>): WifiAccessPointEntry {
            return WifiAccessPointEntry(
                ssid = map["ssid"] as? String ?: "",
                bssid = map["bssid"] as? String ?: "",
                frequency = (map["frequency"] as? Number)?.toInt() ?: 0,
                level = (map["level"] as? Number)?.toInt() ?: 0
            )
        }
    }
}

class WifiController {
    companion object {
        private const val CHANNEL_0_FREQUENCY = 2407
        private const val CHANNEL_14_FREQUENCY = 2484
        private const val CHANNEL_WIDTH = 5

        fun channelToFrequency(channel: Int): Int {
            return if (channel == 14) CHANNEL_14_FREQUENCY else CHANNEL_0_FREQUENCY + channel * CHANNEL_WIDTH
        }

        fun frequencyToChannel(frequency: Int): Int {
            return if (frequency == CHANNEL_14_FREQUENCY) {
                14
            } else {
                (frequency - CHANNEL_0_FREQUENCY) / CHANNEL_WIDTH
            }
        }
    }

    val handlers: List<AzaharMethodHandler> = listOf(ScanRealWifiAccessPoints(), SetVirtualAccessPoints())

    private inner class ScanRealWifiAccessPoints : AzaharMethodHandler {
        override val name = "scanRealWifiAccessPoints"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val entries = NativeLibrary.scanRealWifiAccessPoints()
            if (entries == null) {
                result.success(null)
                return
            }
            result.success(
                entries.mapNotNull { WifiAccessPointEntry.fromWireEntry(it)?.toChannelMap() }
            )
        }
    }

    private inner class SetVirtualAccessPoints : AzaharMethodHandler {
        override val name = "setVirtualAccessPoints"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val accessPoints = call.argument<List<Map<String, Any?>>>("accessPoints")
            if (accessPoints == null) {
                NativeLibrary.setVirtualAccessPoints(null)
            } else {
                val entries = accessPoints
                    .map { WifiAccessPointEntry.fromChannelMap(it).toWireEntry() }
                    .toTypedArray()
                NativeLibrary.setVirtualAccessPoints(entries)
            }
            result.success(null)
        }
    }
}
