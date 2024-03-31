package com.ramen.recipe.data.storage.remote

import com.ramen.recipe.data.remote.AutocompleteIngredientApi
import com.ramen.recipe.data.remote.AutocompleteIngredientsWrapper
import com.ramen.recipe.data.remote.IngredientApi
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