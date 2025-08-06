package com.ramen.recipe.domain.usecase

import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.Ingredient
import com.ramen.recipe.domain.model.SearchRecipe
import kotlin.time.Duration

class RecommendRecipeByIngredients(
    private val recipesRepository: RecipesRepository,
    private val retrieveIngredients: RetrieveIngredients
) {
    suspend operator fun invoke(selectedIngredients: List<String> = emptyList()): List<SearchRecipe> {
        val ingredients = selectedIngredients.ifEmpty {
            retrieveIngredients()
                .map {
                    it.name
                }
        }
        println(ingredients)
        return recipesRepository.searchByIngredients(ingredients)
    }
}