package com.ramen.recipe.data.remote

import com.ramen.recipe.data.model.Recipe
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.parameter

internal class RecipesRemote(private val httpClient: HttpClient) {


    suspend fun searchRecipesByIngredients(ingredients: String): List<Recipe> {
        return httpClient.get(urlString = SEARCH_INGREDIENT_PATH) {
            parameter(QUERY_PARAM, ingredients)
            parameter("ranking", 2)
            parameter("number", 40)
            parameter("limitLicense", false)
            parameter("ignorePantry", true)
        }.body()

    }

    companion object {
        private const val SEARCH_INGREDIENT_PATH = "/recipes/findByIngredients"
        private const val QUERY_PARAM = "ingredients"
    }

}