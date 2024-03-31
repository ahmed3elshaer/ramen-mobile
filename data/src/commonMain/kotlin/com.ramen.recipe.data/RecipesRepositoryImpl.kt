package com.ramen.recipe.data

import com.ramen.recipe.data.model.toDomain
import com.ramen.recipe.data.remote.RecipesRemote
import com.ramen.recipe.domain.RecipesRepository
import com.ramen.recipe.domain.model.Recipe
import com.ramen.recipe.domain.model.SearchRecipe

internal class RecipesRepositoryImpl(
    private val remote: RecipesRemote
) : RecipesRepository {
    override suspend fun searchByIngredients(ingredients: List<String>): List<SearchRecipe> {
        return remote
            .searchRecipesByIngredients(ingredients = ingredients.joinToString { "$it," })
            .map { it.toDomain() }
    }

    override suspend fun getRecipeInfo(id: String): Recipe {
        return remote
            .getRecipeInfo(id)
            .toDomain()
    }

}