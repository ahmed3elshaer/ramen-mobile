package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.usecase.RetrieveIngredients
import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.Recipe
import org.koin.core.logger.Logger

class RecommendRecipeByIngredients(
    private val recipesRepository: RecipesRepository,
    private val retrieveIngredients: RetrieveIngredients
) {
    suspend operator fun invoke(): List<Recipe> {
        val ingredients = retrieveIngredients()
            println(ingredients)
        return recipesRepository.searchByIngredients(ingredients
            .map { it.name })
    }
}