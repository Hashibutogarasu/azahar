// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

class BiMap<K, V> {
    private val forward: MutableMap<K, V> = HashMap()
    private val backward: MutableMap<V, K> = HashMap()

    @Synchronized
    fun add(key: K, value: V) {
        forward[key] = value
        backward[value] = key
    }

    @Synchronized
    fun getForward(key: K): V? = forward[key]

    @Synchronized
    fun getBackward(key: V): K? = backward[key]
}
