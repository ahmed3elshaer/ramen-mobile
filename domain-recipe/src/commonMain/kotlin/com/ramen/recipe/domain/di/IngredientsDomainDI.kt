package com.ramen.ingredients.domain.di

import com.ramen.ingredients.domain.usecase.RecommendIngredientSearch
import com.ramen.recipe.domain.usecase.RetrieveIngredients
import com.ramen.recipe.domain.usecase.StoreIngredient
import org.koin.dsl.module

object IngredientsDomainDI {
    val module = module {
        factory { RecommendIngredientSearch(ingredientsRepository = get()) }
        factory { RetrieveIngredients(ingredientsRepository = get()) }
        factory { StoreIngredient(ingredientsRepository = get()) }
    }
}