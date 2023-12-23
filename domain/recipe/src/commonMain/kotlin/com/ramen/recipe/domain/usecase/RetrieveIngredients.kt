package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.ingredients.domain.model.Ingredient
import kotlinx.datetime.Clock
import kotlin.time.Duration

class RetrieveIngredients(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(): List<Ingredient> {
        return ingredientsRepository.retrieveIngredients()
    }
}