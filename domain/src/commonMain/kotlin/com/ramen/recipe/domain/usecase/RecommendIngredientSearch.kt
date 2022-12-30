package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.recipe.domain.model.AutocompleteIngredient

class RecommendIngredientSearch(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(query: String): List<AutocompleteIngredient> {
        return ingredientsRepository.findIngredient(query)
            .map {
                AutocompleteIngredient(
                    it.id,
                    "https://spoonacular.com/cdn/ingredients_250x250/" + it.image,
                    it.name
                )
            }
    }
}