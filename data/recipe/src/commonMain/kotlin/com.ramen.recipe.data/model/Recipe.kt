package com.ramen.recipe.data.model

import com.ramen.ingredient.data.model.Ingredient
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Recipe(
    @SerialName("id")
    val id: Int = 0,
    @SerialName("image")
    val image: String = "",
    @SerialName("imageType")
    val imageType: String = "",
    @SerialName("likes")
    val likes: Int = 0,
    @SerialName("missedIngredients")
    val missedIngredients: List<Ingredient> = listOf(),
    @SerialName("title")
    val title: String = "",
    @SerialName("unusedIngredients")
    val unusedIngredients: List<Ingredient> = listOf(),
    @SerialName("usedIngredients")
    val usedIngredients: List<Ingredient> = listOf()
)