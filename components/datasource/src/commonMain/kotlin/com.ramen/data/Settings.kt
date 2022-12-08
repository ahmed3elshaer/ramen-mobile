package com.ramen.data

import com.russhwolf.settings.Settings
import io.github.aakira.napier.Napier
import kotlinx.serialization.KSerializer
import kotlinx.serialization.json.Json

class Settings(private val settings: Settings) {

    @Suppress("UNCHECKED_CAST")
    fun <T> putSetting(key: String, value: Any, serializer: KSerializer<T>) =
        try {
            settings.putString(key, Json.encodeToString(serializer, value as T))
        } catch (e: Exception) {
            Napier.e { e.stackTraceToString() }

        }

    fun <T> getSetting(key: String, serializer: KSerializer<T>): T? {
        return try {
            settings.getStringOrNull(key)?.let {
                Json.decodeFromString(
                    serializer,
                    it
                )
            }
        } catch (e: Exception) {
            Napier.e { e.stackTraceToString() }
            clearSetting(key)
            null
        }
    }

    private fun clearSetting(key: String) {
        settings.remove(key)
    }
}