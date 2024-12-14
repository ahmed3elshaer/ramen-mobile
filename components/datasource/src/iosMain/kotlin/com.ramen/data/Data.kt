package com.ramen.data

import com.ramen.data.network.httpClient
import com.russhwolf.settings.NSUserDefaultsSettings
import org.koin.core.module.Module
import org.koin.dsl.module
import platform.Foundation.NSUserDefaults

actual fun dataComponentModule(withLog: Boolean): Module = module {
    single {
        Settings(NSUserDefaultsSettings(NSUserDefaults.standardUserDefaults()))
    }
    single { httpClient(withLog) }
}