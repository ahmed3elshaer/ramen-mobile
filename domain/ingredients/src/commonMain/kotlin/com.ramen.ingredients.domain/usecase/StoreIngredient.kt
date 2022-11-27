package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlin.time.Duration

class StoreIngredient(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(
        autocompleteIngredient: AutocompleteIngredient, expiryDuration: Duration
    ) {
        val rawIngredient = ingredientsRepository.getIngredientInfo(autocompleteIngredient.id)
        val now = Clock.System.now()
        val timedIngredient = rawIngredient.copy(
            storedAt = now.epochSeconds,
            expiryDuration = expiryDuration,
            expirationAt = (now + expiryDuration).epochSeconds
        )
        ingredientsRepository.storeIngredient(timedIngredient)
    }
}