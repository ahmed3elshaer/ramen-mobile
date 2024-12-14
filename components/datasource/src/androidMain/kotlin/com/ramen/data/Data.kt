package com.ramen.data

import android.content.Context
import com.ramen.data.network.httpClient
import com.russhwolf.settings.SharedPreferencesSettings
import org.koin.core.module.Module
import org.koin.dsl.module

actual fun dataComponentModule(withLog: Boolean): Module = module {
    single {
        Settings(
            SharedPreferencesSettings(
                get<Context>().getSharedPreferences(
                    "ramen-pref",
                    Context.MODE_PRIVATE
                )
            )
        )
    }
    single { httpClient(withLog) }
}