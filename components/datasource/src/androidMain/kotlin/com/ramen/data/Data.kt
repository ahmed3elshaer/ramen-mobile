package com.ramen.data

import android.content.Context
import com.ramen.data.network.httpClient
import com.russhwolf.settings.AndroidSettings
import org.koin.core.module.Module
import org.koin.dsl.module

actual fun dataComponentModule(withLog: Boolean): Module = module {
    single {
        Settings(
            AndroidSettings(
                get<Context>().getSharedPreferences(
                    "ramen-pref",
                    Context.MODE_PRIVATE
                )
            )
        )
    }
    single { httpClient(withLog) }
}