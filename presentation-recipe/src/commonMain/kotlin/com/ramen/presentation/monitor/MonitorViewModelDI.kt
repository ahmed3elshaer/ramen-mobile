package com.ramen.presentation.monitor

import com.ramen.recipe.domain.usecase.RetrieveIngredientsUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientUseCase
import org.koin.core.module.dsl.viewModel
import org.koin.dsl.module

object MonitorViewModelDI {
	val module = module {
		viewModel {
			MonitorViewModel(
				retrieveIngredientsUseCase = get<RetrieveIngredientsUseCase>(),
				storeIngredientUseCase = get<StoreIngredientUseCase>()
			)
		}
	}
} 