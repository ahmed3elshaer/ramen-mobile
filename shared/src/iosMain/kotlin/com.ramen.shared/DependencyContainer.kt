package com.ramen.shared

import com.ramen.data.dataComponentModule
import org.koin.core.Koin
import org.koin.core.context.startKoin
import org.koin.dsl.module

object DependencyContainer {
    val koinApp: Koin by lazy {
        startKoin {
            modules(module {
                includes(dataComponentModule(true))
                includes(dependencyGraph)
            })
        }.koin
    }

    inline fun <reified T : Any> getInstance() = koinApp.get<T>()

}