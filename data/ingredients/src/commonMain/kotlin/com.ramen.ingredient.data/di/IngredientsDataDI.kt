package com.ramen.ingredient.data.di

import com.ramen.ingredient.data.IngredientsRepositoryImpl
import com.ramen.ingredient.data.remote.IngredientsRemote
import com.ramen.ingredient.data.storage.IngredientsStorage
import com.ramen.ingredients.domain.IngredientsRepository
import org.koin.dsl.module

object IngredientsDataDI {

    val module = module {
        single { IngredientsRemote(httpClient = get()) }
        single { IngredientsStorage(settings = get()) }
        single<IngredientsRepository> {
            IngredientsRepositoryImpl(
                remote = get(),
                storage = get()
            )
        }
    }
}