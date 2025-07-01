package com.ramen.recipe.domain.usecase

import com.ramen.presentation.Effect
import com.ramen.recipe.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.Ingredient

sealed interface RetrieveIngredientsEffect : Effect {
    data class Success(val ingredients: List<Ingredient>) : RetrieveIngredientsEffect
    data class Failure(val error: Throwable) : RetrieveIngredientsEffect
    // Optional: object Loading : RetrieveIngredientsEffect
}

class RetrieveIngredientsUseCase(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(): RetrieveIngredientsEffect {
        return try {
            // Optional: Emit Loading effect if desired
            // emit(RetrieveIngredientsEffect.Loading)
            val ingredients = ingredientsRepository.retrieveIngredients()
            RetrieveIngredientsEffect.Success(ingredients)
        } catch (e: Exception) {
            RetrieveIngredientsEffect.Failure(e)
        }
    }
}