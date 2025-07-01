package com.ramen.recipe.domain.usecase

import com.ramen.presentation.Effect
import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.Recipe

sealed interface GetRecipeInfoEffect : Effect {
    data class Success(val recipe: Recipe) : GetRecipeInfoEffect
    data class Failure(val error: Throwable) : GetRecipeInfoEffect
    object Loading : GetRecipeInfoEffect // Optional: if you want to represent loading state as an effect
}

class GetRecipeInfoUseCase(private val recipesRepository: RecipesRepository) {
    suspend operator fun invoke(id: String): GetRecipeInfoEffect {
        return try {
            // Optional: Emit Loading effect if desired
            // emit(GetRecipeInfoEffect.Loading) 
            val recipe = recipesRepository.getRecipeInfo(id)
            GetRecipeInfoEffect.Success(recipe)
        } catch (e: Exception) {
            GetRecipeInfoEffect.Failure(e)
        }
    }
}