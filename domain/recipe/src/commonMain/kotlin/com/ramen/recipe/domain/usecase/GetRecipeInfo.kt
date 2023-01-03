package com.ramen.recipe.domain.usecase

import com.ramen.recipe.domain.RecipesRepository

class GetRecipeInfo(private val recipesRepository: RecipesRepository) {
    suspend operator fun invoke(id: String) = recipesRepository
        .getRecipeInfo(id)
}