package com.ramen.recipe.domain.usecase

import com.ramen.recipe.domain.IngredientsRepository
import com.ramen.recipe.domain.model.Ingredient

class RetrieveIngredients(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(): List<Ingredient> {
        return ingredientsRepository.retrieveIngredients()
    }
}