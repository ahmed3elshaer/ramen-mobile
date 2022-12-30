package com.ramen.recipe.domain.model

data class Recipe(
    val aggregateLikes: Int,
    val analyzedInstructions: List<Any>,
    val cheap: Boolean,
    val creditsText: String,
    val cuisines: List<Any>,
    val dairyFree: Boolean,
    val diets: List<Any>,
    val dishTypes: List<String>,
    val extendedIngredients: List<ExtendedIngredient>,
    val gaps: String,
    val glutenFree: Boolean,
    val healthScore: Double,
    val id: Int,
    val image: String,
    val imageType: String,
    val instructions: String,
    val ketogenic: Boolean,
    val license: String,
    val lowFodmap: Boolean,
    val occasions: List<Any>,
    val pricePerServing: Double,
    val readyInMinutes: Int,
    val servings: Int,
    val sourceName: String,
    val sourceUrl: String,
    val spoonacularScore: Double,
    val spoonacularSourceUrl: String,
    val summary: String,
    val sustainable: Boolean,
    val title: String,
    val vegan: Boolean,
    val vegetarian: Boolean,
    val veryHealthy: Boolean,
    val veryPopular: Boolean,
    val weightWatcherSmartPoints: Int,
    val whole30: Boolean,
    val winePairing: WinePairing
) {
    data class ExtendedIngredient(
        val aisle: String,
        val amount: Double,
        val consistency: String,
        val id: Int,
        val image: String,
        val measures: Measures,
        val meta: List<String>,
        val name: String,
        val original: String,
        val originalName: String,
        val unit: String
    ) {
        data class Measures(
            val metric: Metric,
            val us: Us
        ) {
            data class Metric(
                val amount: Double,
                val unitLong: String,
                val unitShort: String
            )

            data class Us(
                val amount: Double,
                val unitLong: String,
                val unitShort: String
            )
        }
    }

    data class WinePairing(
        val pairedWines: List<String>,
        val pairingText: String,
        val productMatches: List<ProductMatch>
    ) {
        data class ProductMatch(
            val averageRating: Double,
            val description: String,
            val id: Int,
            val imageUrl: String,
            val link: String,
            val price: String,
            val ratingCount: Double,
            val score: Double,
            val title: String
        )
    }
}