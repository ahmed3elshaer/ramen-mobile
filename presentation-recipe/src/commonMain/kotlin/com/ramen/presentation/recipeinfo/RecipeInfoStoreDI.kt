package com.ramen.presentation.recipeinfo

import org.koin.dsl.module

object RecipeInfoStoreDI {
    val module = module {
        factory {
            RecipeInfoStore(getRecipeInfo = get())
        }
    }
}