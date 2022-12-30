package com.ramen.recipe.data.model


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class RecipeApi(
    @SerialName("aggregateLikes")
    val aggregateLikes: Int = 0,
    @SerialName("analyzedInstructions")
    val analyzedInstructions: List<String> = listOf(),
    @SerialName("cheap")
    val cheap: Boolean = false,
    @SerialName("creditsText")
    val creditsText: String = "",
    @SerialName("cuisines")
    val cuisines: List<String> = listOf(),
    @SerialName("dairyFree")
    val dairyFree: Boolean = false,
    @SerialName("diets")
    val diets: List<String> = listOf(),
    @SerialName("dishTypes")
    val dishTypes: List<String> = listOf(),
    @SerialName("extendedIngredients")
    val extendedIngredients: List<ExtendedIngredientApi> = listOf(),
    @SerialName("gaps")
    val gaps: String = "",
    @SerialName("glutenFree")
    val glutenFree: Boolean = false,
    @SerialName("healthScore")
    val healthScore: Double = 0.0,
    @SerialName("id")
    val id: Int = 0,
    @SerialName("image")
    val image: String = "",
    @SerialName("imageType")
    val imageType: String = "",
    @SerialName("instructions")
    val instructions: String = "",
    @SerialName("ketogenic")
    val ketogenic: Boolean = false,
    @SerialName("license")
    val license: String = "",
    @SerialName("lowFodmap")
    val lowFodmap: Boolean = false,
    @SerialName("occasions")
    val occasions: List<String> = listOf(),
    @SerialName("pricePerServing")
    val pricePerServing: Double = 0.0,
    @SerialName("readyInMinutes")
    val readyInMinutes: Int = 0,
    @SerialName("servings")
    val servings: Int = 0,
    @SerialName("sourceName")
    val sourceName: String = "",
    @SerialName("sourceUrl")
    val sourceUrl: String = "",
    @SerialName("spoonacularScore")
    val spoonacularScore: Double = 0.0,
    @SerialName("spoonacularSourceUrl")
    val spoonacularSourceUrl: String = "",
    @SerialName("summary")
    val summary: String = "",
    @SerialName("sustainable")
    val sustainable: Boolean = false,
    @SerialName("title")
    val title: String = "",
    @SerialName("vegan")
    val vegan: Boolean = false,
    @SerialName("vegetarian")
    val vegetarian: Boolean = false,
    @SerialName("veryHealthy")
    val veryHealthy: Boolean = false,
    @SerialName("veryPopular")
    val veryPopular: Boolean = false,
    @SerialName("weightWatcherSmartPoints")
    val weightWatcherSmartPoints: Int = 0,
    @SerialName("whole30")
    val whole30: Boolean = false,
    @SerialName("winePairing")
    val winePairing: WinePairingApi = WinePairingApi()
) {
    @Serializable
    data class ExtendedIngredientApi(
        @SerialName("aisle")
        val aisle: String = "",
        @SerialName("amount")
        val amount: Double = 0.0,
        @SerialName("consitency")
        val consitency: String = "",
        @SerialName("id")
        val id: Int = 0,
        @SerialName("image")
        val image: String = "",
        @SerialName("measures")
        val measures: MeasuresApi = MeasuresApi(),
        @SerialName("meta")
        val meta: List<String> = listOf(),
        @SerialName("name")
        val name: String = "",
        @SerialName("original")
        val original: String = "",
        @SerialName("originalName")
        val originalName: String = "",
        @SerialName("unit")
        val unit: String = ""
    ) {
        @Serializable
        data class MeasuresApi(
            @SerialName("metric")
            val metric: MetricApi = MetricApi(),
            @SerialName("us")
            val us: UsApi = UsApi()
        ) {
            @Serializable
            data class MetricApi(
                @SerialName("amount")
                val amount: Double = 0.0,
                @SerialName("unitLong")
                val unitLong: String = "",
                @SerialName("unitShort")
                val unitShort: String = ""
            )

            @Serializable
            data class UsApi(
                @SerialName("amount")
                val amount: Double = 0.0,
                @SerialName("unitLong")
                val unitLong: String = "",
                @SerialName("unitShort")
                val unitShort: String = ""
            )
        }
    }

    @Serializable
    data class WinePairingApi(
        @SerialName("pairedWines")
        val pairedWines: List<String> = listOf(),
        @SerialName("pairingText")
        val pairingText: String = "",
        @SerialName("productMatches")
        val productMatches: List<ProductMatcheApi> = listOf()
    ) {
        @Serializable
        data class ProductMatcheApi(
            @SerialName("averageRating")
            val averageRating: Double = 0.0,
            @SerialName("description")
            val description: String = "",
            @SerialName("id")
            val id: Int = 0,
            @SerialName("imageUrl")
            val imageUrl: String = "",
            @SerialName("link")
            val link: String = "",
            @SerialName("price")
            val price: String = "",
            @SerialName("ratingCount")
            val ratingCount: Double = 0.0,
            @SerialName("score")
            val score: Double = 0.0,
            @SerialName("title")
            val title: String = ""
        )
    }
}