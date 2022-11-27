package com.ramen.ingredient.data.remote

import com.ramen.ingredient.data.model.Ingredient
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.parameter

internal class IngredientsRemote(private val httpClient: HttpClient) {


    suspend fun searchIngredients(query: String): List<Ingredient> {
        return httpClient.get(urlString = SEARCH_INGREDIENT_PATH) {
            parameter(QUERY_PARAM, query)
        }.body()

    }

    companion object {
        private const val SEARCH_INGREDIENT_PATH = "food/ingredients/autocomplete"
        private const val QUERY_PARAM = "query"
    }

}