package com.ramen.presentation.monitor

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