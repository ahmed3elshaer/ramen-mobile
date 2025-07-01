package com.ramen.presentation.recipe

import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredientsUseCase
import com.ramen.recipe.domain.usecase.RetrieveIngredientsUseCase
import org.koin.core.module.dsl.viewModel
import org.koin.dsl.module

object RecipeViewModelDI {
    val module = module {
        viewModel {
            RecipeViewModel(
                retrieveIngredientsUseCase = get<RetrieveIngredientsUseCase>(),
                recommendRecipeByIngredientsUseCase = get<RecommendRecipeByIngredientsUseCase>()
            )
        }
    }
} 