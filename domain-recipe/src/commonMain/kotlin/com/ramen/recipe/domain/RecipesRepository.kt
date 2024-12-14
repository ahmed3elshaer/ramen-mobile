package com.ramen.recipe.domain

import com.ramen.recipe.domain.model.Recipe
import com.ramen.recipe.domain.model.SearchRecipe

interface RecipesRepository {
    suspend fun searchByIngredients(ingredients: List<String>): List<SearchRecipe>
    suspend fun getRecipeInfo(id: String): Recipe
}