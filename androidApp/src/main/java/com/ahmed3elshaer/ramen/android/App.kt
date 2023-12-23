package com.ahmed3elshaer.ramen.android

import android.app.Application
import com.ramen.data.dataComponentModule
import com.ramen.shared.dependencyGraph
import io.github.aakira.napier.DebugAntilog
import io.github.aakira.napier.Napier
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.GlobalContext.startKoin
import org.koin.dsl.module

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        initKoin()
        Napier.base(DebugAntilog())

    }

    private val appModule = module {
        includes(dataComponentModule(true))
        includes(dependencyGraph)
    }

    private fun initKoin() {
        startKoin {
            androidContext(this@App)
            modules(appModule)
        }
    }


}
