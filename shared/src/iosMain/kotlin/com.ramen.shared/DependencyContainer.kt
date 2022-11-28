package com.ramen.shared

import com.ramen.data.dataComponentModule
import com.ramen.presentation.monitor.MonitorStore
import org.koin.core.Koin
import org.koin.core.KoinApplication
import org.koin.core.component.KoinComponent
import org.koin.core.context.startKoin
import org.koin.dsl.module

object DependencyContainer {
    fun initKoin(): KoinApplication {
        return startKoin {
            modules(module {
                includes(dataComponentModule(true))
                includes(dependencyGraph)
            })
        }
    }

    @Suppress("unused") // Called from Swift
    object KotlinDependencies : KoinComponent {
        fun getMonitorStore(): MonitorStore = getKoin().get<MonitorStore>()
    }
}
