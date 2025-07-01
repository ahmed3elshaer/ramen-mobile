package com.ramen.presentation.store

import com.ramen.recipe.domain.usecase.RecommendIngredientSearchUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientUseCase
import org.koin.core.module.dsl.viewModel
import org.koin.dsl.module

object StoreIngredientViewModelDI {
	val module = module {
		viewModel {
			StoreIngredientViewModel(
					recommendIngredientSearchUseCase = get<RecommendIngredientSearchUseCase>(),
					storeIngredientUseCase = get<StoreIngredientUseCase>()
			)
		}
	}
} 