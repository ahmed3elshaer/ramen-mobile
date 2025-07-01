package com.ramen.recipe.domain.usecase

import com.ramen.presentation.Effect
import com.ramen.recipe.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import kotlinx.datetime.Clock
import kotlin.time.Duration
import kotlin.time.ExperimentalTime

sealed interface StoreIngredientEffect : Effect {
    object Success : StoreIngredientEffect
    data class Failure(val error: Throwable) : StoreIngredientEffect
    // Optional: object Processing : StoreIngredientEffect
}

class StoreIngredientUseCase(private val ingredientsRepository: IngredientsRepository) {
    @OptIn(ExperimentalTime::class)
    suspend operator fun invoke(
        autocompleteIngredient: AutocompleteIngredient, expiryDuration: Duration
    ): StoreIngredientEffect {
        return try {
            // Optional: Emit Processing effect if desired
            // emit(StoreIngredientEffect.Processing)
            val rawIngredient = ingredientsRepository.getIngredientInfo(autocompleteIngredient.id)
            val now = Clock.System.now()
            val timedIngredient = rawIngredient.copy(
                storedAt = now.toEpochMilliseconds(),
                expiryDuration = expiryDuration,
                expirationAt = (now + expiryDuration).toEpochMilliseconds()
            )
            ingredientsRepository.storeIngredient(timedIngredient)
            StoreIngredientEffect.Success
        } catch (e: Exception) {
            StoreIngredientEffect.Failure(e)
        }
    }
}