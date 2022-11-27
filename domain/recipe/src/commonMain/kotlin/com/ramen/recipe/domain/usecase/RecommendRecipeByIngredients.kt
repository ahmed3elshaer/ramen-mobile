package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.usecase.RetrieveIngredients
import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.Recipe

class RecommendRecipeByIngredients(
    private val recipesRepository: RecipesRepository,
    private val retrieveIngredients: RetrieveIngredients
) {
    suspend operator fun invoke(): List<Recipe> {
        val ingredients = retrieveIngredients()
            .map { it.name }
        return recipesRepository.searchByIngredients(ingredients)
    }
}