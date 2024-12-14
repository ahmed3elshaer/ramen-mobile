package com.ramen.ingredients.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.AutocompleteIngredient

class RecommendIngredientSearch(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(query: String): List<AutocompleteIngredient> {
        return ingredientsRepository.findIngredient(query)
    }
}