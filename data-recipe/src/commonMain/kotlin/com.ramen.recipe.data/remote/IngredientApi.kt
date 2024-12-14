package com.ramen.ingredient.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.time.Duration

@Serializable
data class IngredientApi(
    @SerialName("aisle")
    val aisle: String = "",
    @SerialName("amount")
    val amount: Double = 0.0,
    @SerialName("categoryPath")
    val categoryPath: List<String> = listOf(),
    @SerialName("consistency")
    val consistency: String = "",
    @SerialName("estimatedCost")
    val estimatedCost: EstimatedCost = EstimatedCost(),
    @SerialName("id")
    val id: Int = 0,
    @SerialName("image")
    val image: String = "",
    @SerialName("name")
    val name: String = "",
    @SerialName("nutrition")
    val nutrition: Nutrition = Nutrition(),
    @SerialName("original")
    val original: String = "",
    @SerialName("originalName")
    val originalName: String = "",
    @SerialName("possibleUnits")
    val possibleUnits: List<String> = listOf(),
    @SerialName("shoppingListUnits")
    val shoppingListUnits: List<String> = listOf(),
    @SerialName("unit")
    val unit: String = "",
    @SerialName("unitLong")
    val unitLong: String = "",
    @SerialName("unitShort")
    val unitShort: String = "",
    @SerialName("storedAt")
    val storedAt: Long = 0L,
    @SerialName("expirationAt")
    val expirationAt: Long = 0L,
    @SerialName("expiryDuration")
    val expiryDuration: Duration = Duration.ZERO
) {
    @Serializable
    data class EstimatedCost(
        @SerialName("unit")
        val unit: String = "",
        @SerialName("value")
        val value: Double = 0.0
    )

    @Serializable
    data class Nutrition(
        @SerialName("caloricBreakdown")
        val caloricBreakdown: CaloricBreakdown = CaloricBreakdown(),
        @SerialName("flavonoids")
        val flavonoids: List<Flavonoid> = listOf(),
        @SerialName("nutrients")
        val nutrients: List<Nutrient> = listOf(),
        @SerialName("properties")
        val properties: List<Property> = listOf(),
        @SerialName("weightPerServing")
        val weightPerServing: WeightPerServing = WeightPerServing()
    ) {
        @Serializable
        data class CaloricBreakdown(
            @SerialName("percentCarbs")
            val percentCarbs: Double = 0.0,
            @SerialName("percentFat")
            val percentFat: Double = 0.0,
            @SerialName("percentProtein")
            val percentProtein: Double = 0.0
        )

        @Serializable
        data class Nutrient(
            @SerialName("amount")
            val amount: Double = 0.0,
            @SerialName("name")
            val name: String = "",
            @SerialName("percentOfDailyNeeds")
            val percentOfDailyNeeds: Double = 0.0,
            @SerialName("unit")
            val unit: String = ""
        )

        @Serializable
        data class Property(
            @SerialName("amount")
            val amount: Double = 0.0,
            @SerialName("name")
            val name: String = "",
            @SerialName("unit")
            val unit: String = ""
        )

        @Serializable
        data class WeightPerServing(
            @SerialName("amount")
            val amount: Int = 0,
            @SerialName("unit")
            val unit: String = ""
        )

        @Serializable
        data class Flavonoid(
            @SerialName("amount")
            val amount: Double = 0.0,
            @SerialName("name")
            val name: String = "",
            @SerialName("unit")
            val unit: String = ""
        )
    }
}




