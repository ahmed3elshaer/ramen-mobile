package com.ramen.presentation.store.di

import com.ramen.presentation.store.StoreIngredientStore
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