package com.ramen.recipe.domain.model


data class SearchRecipe(
    val id: Int,
    val image: String,
    val imageType: String,
    val likes: Int,
    val missedIngredients: List<Ingredient>,
    val title: String,
    val unusedIngredients: List<Ingredient>,
    val usedIngredients: List<Ingredient>
) {
    data class Ingredient(
        val aisle: String,
        val amount: Double,
        val id: Int,
        val image: String,
        val name: String,
        val original: String,
        val originalName: String,
        val unit: String,
        val unitLong: String,
        val unitShort: String
    )
}

