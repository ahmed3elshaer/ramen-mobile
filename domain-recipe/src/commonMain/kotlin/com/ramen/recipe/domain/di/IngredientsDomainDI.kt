package com.ramen.recipe.domain.di

import com.ramen.recipe.domain.usecase.RecommendIngredientSearchUseCase
import com.ramen.recipe.domain.usecase.RetrieveIngredientsUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientUseCase
import org.koin.dsl.module

object IngredientsDomainDI {
    val module = module {
        factory { RecommendIngredientSearchUseCase(ingredientsRepository = get()) }
        factory { RetrieveIngredientsUseCase(ingredientsRepository = get()) }
        factory { StoreIngredientUseCase(ingredientsRepository = get()) }
    }
}