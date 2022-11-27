package com.ramen.ingredients.domain

import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.ingredients.domain.model.Ingredient

interface IngredientsRepository {
    suspend fun findIngredient(query: String): List<AutocompleteIngredient>
    suspend fun storeIngredient(ingredient: Ingredient)
    suspend fun retrieveIngredients(): List<Ingredient>
    suspend fun getIngredientInfo(id: Int): Ingredient
}