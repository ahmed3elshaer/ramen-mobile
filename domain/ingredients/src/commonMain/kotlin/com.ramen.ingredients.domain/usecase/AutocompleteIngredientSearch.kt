package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.Ingredient

class AutocompleteIngredientSearch(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(query: String): List<Ingredient> {
        return ingredientsRepository.findIngredient(query)
    }
}