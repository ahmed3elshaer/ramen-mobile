package com.ramen.presentation.recipeinfo.di

import com.ramen.presentation.recipeinfo.RecipeInfoStore
import org.koin.dsl.module

object RecipeInfoStoreDI {
    val module = module {
        factory {
            RecipeInfoStore(getRecipeInfo = get())
        }
    }
}