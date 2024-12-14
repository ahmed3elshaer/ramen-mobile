package com.ramen.recipe.domain.di

import com.ramen.recipe.domain.usecase.GetRecipeInfo
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredients
import org.koin.dsl.module

object RecipeDomainDI {
    val module = module {
        factory {
            RecommendRecipeByIngredients(
                recipesRepository = get(),
                retrieveIngredients = get()
            )
        }
        factory {
            GetRecipeInfo(
                recipesRepository = get()
            )
        }
    }
}