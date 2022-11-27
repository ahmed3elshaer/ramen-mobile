package com.ramen.ingredient.data.storage.remote

import com.ramen.ingredient.data.model.AutocompleteIngredient
import com.ramen.ingredient.data.model.Ingredient
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.parameter

internal class IngredientsRemote(private val httpClient: HttpClient) {


    suspend fun searchIngredients(query: String): List<AutocompleteIngredient> {
        return httpClient.get(urlString = SEARCH_INGREDIENT_PATH) {
            parameter(QUERY_PARAM, query)
        }.body()

    }

    suspend fun getIngredientInfo(id: String): Ingredient {
        return httpClient.get(urlString = getIngredientInfoPath(id))
            .body()

    }

    companion object {
        private const val SEARCH_INGREDIENT_PATH = "food/ingredients/autocomplete"
        fun getIngredientInfoPath(id: String) = "food/ingredients/${id}/information"
        private const val QUERY_PARAM = "query"
    }

}