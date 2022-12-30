package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.recipe.domain.model.AutocompleteIngredient
import kotlinx.datetime.Clock
import kotlin.time.Duration

class StoreIngredient(private val ingredientsRepository: IngredientsRepository) {
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