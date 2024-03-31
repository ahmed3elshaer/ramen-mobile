package com.ramen.recipe.data.remote

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class AutocompleteIngredientApi(
    @SerialName("id")
    val id: Int = 0,
    @SerialName("image")
    val image: String = "",
    @SerialName("name")
    val name: String = ""
)

@Serializable
internal data class AutocompleteIngredientsWrapper(
    @SerialName("results")
    val results: List<AutocompleteIngredientApi> = listOf()
)