package com.ramen.ingredients.domain.di

import com.ramen.ingredients.domain.usecase.AutocompleteIngredientSearch
import com.ramen.ingredients.domain.usecase.RetrieveIngredients
import com.ramen.ingredients.domain.usecase.StoreIngredient
import org.koin.dsl.module

object IngredientsDomainDI {
    val module = module {
        factory { AutocompleteIngredientSearch(ingredientsRepository = get()) }
        factory { RetrieveIngredients(ingredientsRepository = get()) }
        factory { StoreIngredient(ingredientsRepository = get()) }
    }
}