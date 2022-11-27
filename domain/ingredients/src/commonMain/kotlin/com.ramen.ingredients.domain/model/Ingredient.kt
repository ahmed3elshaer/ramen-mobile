package com.ramen.ingredients.domain.model

import kotlin.time.Duration

data class Ingredient(
    val aisle: String,
    val amount: Double,
    val categoryPath: List<String>,
    val consistency: String,
    val estimatedCost: EstimatedCost,
    val id: Int,
    val image: String,
    val name: String,
    val nutrition: Nutrition,
    val original: String,
    val originalName: String,
    val possibleUnits: List<String>,
    val shoppingListUnits: List<String>,
    val unit: String,
    val unitLong: String,
    val unitShort: String,
    val storedAt: Long,
    val expirationAt: Long,
    val expiryDuration: Duration
) {
    data class EstimatedCost(
        val unit: String,
        val value: Double
    )

    data class Nutrition(
        val caloricBreakdown: CaloricBreakdown,
        val flavonoids: List<Flavonoid>,
        val nutrients: List<Nutrient>,
        val properties: List<Property>,
        val weightPerServing: WeightPerServing
    ) {
        data class CaloricBreakdown(
            val percentCarbs: Double,
            val percentFat: Double,
            val percentProtein: Double
        )

        data class Flavonoid(
            val amount: Double,
            val name: String,
            val unit: String
        )

        data class Nutrient(
            val amount: Double,
            val name: String,
            val percentOfDailyNeeds: Double,
            val unit: String
        )

        data class Property(
            val amount: Double,
            val name: String,
            val unit: String
        )
    }

    data class WeightPerServing(
        val amount: Int,
        val unit: String
    )

}












