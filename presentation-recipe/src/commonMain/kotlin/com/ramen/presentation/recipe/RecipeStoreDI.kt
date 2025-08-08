package com.ramen.presentation.recipe

import org.koin.dsl.module

object RecipeStoreDI {
    val module = module {
        factory {
            RecipeStore(
                recommendRecipeByIngredients = get(),
                retrieveIngredients = get()
            )
        }
    }
}