package com.ramen.recipe.domain

import com.ramen.recipe.domain.model.Recipe

interface RecipesRepository {
    fun searchByIngredients(ingredients: List<String>): List<Recipe>
}