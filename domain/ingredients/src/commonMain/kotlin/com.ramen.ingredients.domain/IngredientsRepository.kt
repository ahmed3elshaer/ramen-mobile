package com.ramen.ingredients.domain

import com.ramen.ingredients.domain.model.Ingredient

interface IngredientsRepository {
    suspend fun findIngredient(query: String): List<Ingredient>
    suspend fun storeIngredient(ingredient: Ingredient)
    suspend fun retrieveIngredients(): List<Ingredient>
}