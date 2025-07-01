package com.ramen.recipe.domain.usecase

import com.ramen.presentation.Effect
import com.ramen.recipe.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient

sealed interface RecommendIngredientSearchEffect : Effect {
    data class Success(val ingredients: List<AutocompleteIngredient>) : RecommendIngredientSearchEffect
    data class Failure(val error: Throwable) : RecommendIngredientSearchEffect
    // Optional: object Loading : RecommendIngredientSearchEffect
}

class RecommendIngredientSearchUseCase(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(query: String): RecommendIngredientSearchEffect {
        return try {
            // Optional: Emit Loading effect if desired
            // emit(RecommendIngredientSearchEffect.Loading)
            val ingredients = ingredientsRepository.findIngredient(query)
            RecommendIngredientSearchEffect.Success(ingredients)
        } catch (e: Exception) {
            RecommendIngredientSearchEffect.Failure(e)
        }
    }
}