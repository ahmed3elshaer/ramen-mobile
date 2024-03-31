package com.ramen.presentation.store

import org.koin.dsl.module

object StoreIngredientDI {
	val module = module {
		factory {
			StoreIngredientStore(
					recommendIngredientSearch = get(),
					storeIngredient = get()
			)
		}
	}
}