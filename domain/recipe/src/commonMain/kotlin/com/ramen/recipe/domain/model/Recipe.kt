package com.ramen.recipe.domain.model

import com.ramen.ingredients.domain.model.Ingredient

data class Recipe(
    val id: Int,
    val image: String,
    val imageType: String,
    val likes: Int,
    val missedIngredientCount: Int,
    val missedIngredients: List<Ingredient>,
    val title: String,
    val unusedIngredients: List<Ingredient>,
    val usedIngredients: List<Ingredient>
)