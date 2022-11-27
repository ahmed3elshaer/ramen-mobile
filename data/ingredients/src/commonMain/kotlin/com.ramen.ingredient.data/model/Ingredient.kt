package com.ramen.ingredient.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

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
    val unitShort: String = "",
    @SerialName("storeDate")
    val storeDate: Long = 0L,
    @SerialName("expiryDate")
    val expiryDate: Long = 0L
)