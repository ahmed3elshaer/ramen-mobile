package com.ramen.shared

import com.ramen.data.dataComponentModule
import com.ramen.presentation.monitor.MonitorStore
import com.ramen.presentation.recipe.RecipeStore
import com.ramen.presentation.store.StoreIngredientStore
import io.github.aakira.napier.DebugAntilog
import io.github.aakira.napier.Napier
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

    fun initLogger() {
        Napier.base(DebugAntilog())
    }

    object KotlinDependencies : KoinComponent {
        fun getMonitorStore(): MonitorStore = getKoin().get<MonitorStore>()
        fun getStoreIngredient(): StoreIngredientStore = getKoin().get<StoreIngredientStore>()
        fun getRecipeStore(): RecipeStore = getKoin().get<RecipeStore>()
    }
}
