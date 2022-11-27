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
) {
    @Serializable
    data class Ingredient(
        @SerialName("aisle")
        val aisle: String = "",
        @SerialName("amount")
        val amount: Double = 0.0,
        @SerialName("id")
        val id: Int = 0,
        @SerialName("image")
        val image: String = "",
        @SerialName("name")
        val name: String = "",
        @SerialName("original")
        val original: String = "",
        @SerialName("originalName")
        val originalName: String = "",
        @SerialName("unit")
        val unit: String = "",
        @SerialName("unitLong")
        val unitLong: String = "",
        @SerialName("unitShort")
        val unitShort: String = ""
    )
}