package com.ramen.recipe.domain.usecase

import com.ramen.presentation.Effect
import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.SearchRecipe

sealed interface RecommendRecipeByIngredientsEffect : Effect {
    data class Success(val recipes: List<SearchRecipe>) : RecommendRecipeByIngredientsEffect
    data class Failure(val error: Throwable) : RecommendRecipeByIngredientsEffect
}

class RecommendRecipeByIngredientsUseCase(
    private val recipesRepository: RecipesRepository
) {
    suspend operator fun invoke(ingredientNames: List<String>): RecommendRecipeByIngredientsEffect {
        return try {
            val recipes = recipesRepository.searchByIngredients(ingredientNames)
            RecommendRecipeByIngredientsEffect.Success(recipes)
        } catch (e: Exception) {
            RecommendRecipeByIngredientsEffect.Failure(e)
        }
    }
}