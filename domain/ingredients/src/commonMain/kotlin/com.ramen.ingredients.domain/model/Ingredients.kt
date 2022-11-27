package com.ramen.ingredients.domain.model

data class Ingredient(
    val aisle: String,
    val amount: Double,
    val id: Int,
    val storeDate: Long,
    val expiryDate: Long,
    val image: String,
    val name: String,
    val unit: String,
    val unitLong: String,
    val unitShort: String
)