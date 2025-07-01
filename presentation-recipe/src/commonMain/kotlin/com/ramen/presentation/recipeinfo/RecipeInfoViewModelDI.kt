package com.ramen.presentation.recipeinfo

import com.ramen.recipe.domain.usecase.GetRecipeInfoUseCase
import org.koin.core.module.dsl.viewModel
import org.koin.dsl.module

object RecipeInfoViewModelDI {
    val module = module {
        viewModel {
            RecipeInfoViewModel(
                getRecipeInfoUseCase = get<GetRecipeInfoUseCase>()
            )
        }
    }
} 