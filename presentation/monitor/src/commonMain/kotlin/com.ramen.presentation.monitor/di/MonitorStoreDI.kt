package com.ramen.presentation.monitor.di

import com.ramen.presentation.monitor.MonitorStore
import org.koin.dsl.module

object MonitorStoreDI {
    val module = module {
        factory {
            MonitorStore(
                retrieveIngredients = get(),
                storeIngredient = get()
            )
        }
    }
}