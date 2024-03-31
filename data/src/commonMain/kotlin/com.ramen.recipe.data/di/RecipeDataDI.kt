package com.ramen.recipe.data.di

import com.ramen.recipe.data.RecipesRepositoryImpl
import com.ramen.recipe.data.remote.RecipesRemote
import com.ramen.recipe.domain.RecipesRepository
import org.koin.dsl.module

object RecipeDataDI {

    val module = module {
        single { RecipesRemote(httpClient = get()) }
        single<RecipesRepository> {
            RecipesRepositoryImpl(
                remote = get())
        }
    }
}