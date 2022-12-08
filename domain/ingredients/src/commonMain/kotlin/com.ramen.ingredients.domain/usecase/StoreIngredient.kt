package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import kotlinx.datetime.Clock
import kotlin.time.Duration
import kotlin.time.ExperimentalTime
import kotlin.time.days

class StoreIngredient(private val ingredientsRepository: IngredientsRepository) {
    @OptIn(ExperimentalTime::class)
    suspend operator fun invoke(
        autocompleteIngredient: AutocompleteIngredient, expiryDuration: Duration
    ) {
        val rawIngredient = ingredientsRepository.getIngredientInfo(autocompleteIngredient.id)
        val now = Clock.System.now() - 2.days
        val timedIngredient = rawIngredient.copy(
            storedAt = now.toEpochMilliseconds(),
            expiryDuration = expiryDuration,
            expirationAt = (now + expiryDuration).toEpochMilliseconds()
        )
        ingredientsRepository.storeIngredient(timedIngredient)
    }
}