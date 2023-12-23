package com.ramen.presentation.recipe.di

import com.ramen.presentation.recipe.RecipeStore
import org.koin.dsl.module

object RecipeStoreDI {
    val module = module {
        factory {
            RecipeStore(recommendRecipeByIngredients = get())
        }
    }
}