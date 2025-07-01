package com.ramen.recipe.domain.di

import com.ramen.recipe.domain.usecase.GetRecipeInfoUseCase
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredientsUseCase
import org.koin.dsl.module

object RecipeDomainDI {
    val module = module {
        factory {
            RecommendRecipeByIngredientsUseCase(
                recipesRepository = get(),
            )
        }
        factory {
            GetRecipeInfoUseCase(
                recipesRepository = get(),
            )
        }
    }
}