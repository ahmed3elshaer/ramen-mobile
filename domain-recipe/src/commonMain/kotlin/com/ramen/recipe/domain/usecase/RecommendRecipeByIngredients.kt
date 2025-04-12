package com.ramen.recipe.domain.usecase

import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.SearchRecipe

class RecommendRecipeByIngredients(
    private val recipesRepository: RecipesRepository,
    private val retrieveIngredients: RetrieveIngredients
) {
    suspend operator fun invoke(): List<SearchRecipe> {
        val ingredients = retrieveIngredients()
            println(ingredients)
        return recipesRepository.searchByIngredients(ingredients
            .map { it.name })
    }
}