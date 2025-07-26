package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.recipe.domain.IngredientsRepository
import kotlin.time.Clock
import kotlin.time.Duration
import kotlin.time.ExperimentalTime

class StoreIngredient(private val ingredientsRepository: IngredientsRepository) {
    @OptIn(ExperimentalTime::class)
    suspend operator fun invoke(
        autocompleteIngredient: AutocompleteIngredient, expiryDuration: Duration
    ) {
        val rawIngredient = ingredientsRepository.getIngredientInfo(autocompleteIngredient.id)
        val now = Clock.System.now()
        val timedIngredient = rawIngredient.copy(
            storedAt = now.toEpochMilliseconds(),
            expiryDuration = expiryDuration,
            expirationAt = (now + expiryDuration).toEpochMilliseconds()
        )
        ingredientsRepository.storeIngredient(timedIngredient)
    }
}