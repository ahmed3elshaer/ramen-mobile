package com.ramen.recipe.domain.usecase

import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.ingredients.domain.model.Ingredient

class RetrieveIngredients(private val ingredientsRepository: IngredientsRepository) {
    suspend operator fun invoke(): List<Ingredient> {
        return ingredientsRepository.retrieveIngredients()
            .map{
                it.copy(image = "https://spoonacular.com/cdn/ingredients_250x250/" + it.image)
            }
    }
}