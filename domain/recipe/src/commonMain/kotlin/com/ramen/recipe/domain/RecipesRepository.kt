package com.ramen.recipe.domain

import com.ramen.recipe.domain.model.Recipe

interface RecipesRepository {
    suspend fun searchByIngredients(ingredients: List<String>): List<Recipe>
}