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
    companion object {
        val Initial = Recipe(
            aggregateLikes = 0,
            analyzedInstructions = listOf(),
            cheap = false,
            creditsText = "",
            cuisines = listOf(),
            dairyFree = false,
            diets = listOf(),
            dishTypes = listOf(),
            extendedIngredients = listOf(),
            gaps = "",
            glutenFree = false,
            healthScore = 0.0,
            id = 0,
            image = "",
            imageType = "",
            instructions = "",
            ketogenic = false,
            license = "",
            lowFodmap = false,
            occasions = listOf(),
            pricePerServing = 0.0,
            readyInMinutes = 0,
            servings = 0,
            sourceName = "",
            sourceUrl = "",
            spoonacularScore = 0.0,
            spoonacularSourceUrl = "",
            summary = "",
            sustainable = false,
            title = "",
            vegan = false,
            vegetarian = false,
            veryHealthy = false,
            veryPopular = false,
            weightWatcherSmartPoints = 0,
            whole30 = false,
            winePairing = WinePairing(
                pairedWines = listOf(),
                pairingText = "",
                productMatches = listOf()
            )
        )
    }

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