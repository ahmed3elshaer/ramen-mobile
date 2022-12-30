package com.ramen.recipe.data.remote

import com.ramen.recipe.data.model.RecipeApi
import com.ramen.recipe.data.model.SearchRecipeApi
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.parameter

internal class RecipesRemote(private val httpClient: HttpClient) {


    suspend fun searchRecipesByIngredients(ingredients: String): List<SearchRecipeApi> {
        return httpClient
            .get(urlString = SEARCH_INGREDIENT_PATH) {
                parameter("ingredients", ingredients)
                parameter("ranking", 2)
                parameter("number", 100)
                parameter("limitLicense", false)
                parameter("ignorePantry", true)
            }
            .body()

    }

    suspend fun getRecipeInfo(id: String): RecipeApi {
        return httpClient
            .get(urlString = getRecipeInfoPath(id))
            .body()

    }

    companion object {
        private fun getRecipeInfoPath(id: String) = "/recipes/${id}/information"
        private const val SEARCH_INGREDIENT_PATH = "/recipes/findByIngredients"
    }

}