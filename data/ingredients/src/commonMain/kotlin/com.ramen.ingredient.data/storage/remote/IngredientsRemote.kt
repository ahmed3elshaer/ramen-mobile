package com.ramen.ingredient.data.storage.remote

import com.ramen.ingredient.data.model.AutocompleteIngredientApi
import com.ramen.ingredient.data.model.AutocompleteIngredientsWrapper
import com.ramen.ingredient.data.model.IngredientApi
import io.github.aakira.napier.Napier
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import io.ktor.client.request.parameter

internal class IngredientsRemote(private val httpClient: HttpClient) {


    suspend fun searchIngredients(query: String): List<AutocompleteIngredientApi> {
        return httpClient.get(urlString = SEARCH_INGREDIENT_PATH) {
            parameter(QUERY_PARAM, query)
            parameter("language", "en")
            parameter("number", 10)
        }.body<AutocompleteIngredientsWrapper>().results

    }

    suspend fun getIngredientInfo(id: Int): IngredientApi {
        return try {
            return httpClient.get(urlString = getIngredientInfoPath(id))
                .body()
        } catch (e: Exception) {
            Napier.e { e.stackTraceToString() }
            IngredientApi()
        }
    }

    companion object {
        private const val SEARCH_INGREDIENT_PATH = "food/ingredients/search"
        fun getIngredientInfoPath(id: Int) = "food/ingredients/${id}/information"
        private const val QUERY_PARAM = "query"
    }

}