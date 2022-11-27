package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import kotlin.time.Duration

class StoreIngredient(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(expiryDuration: Duration) {

    }
}