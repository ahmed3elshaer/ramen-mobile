package com.ramen.recipe.data.model


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class RecipeApi(
    @SerialName("aggregateLikes")
    val aggregateLikes: Int = 0,
    @SerialName("analyzedInstructions")
    val analyzedInstructions: List<AnalyzedInstructionApi> = listOf(),
    @SerialName("cheap")
    val cheap: Boolean = false,
    @SerialName("cookingMinutes")
    val cookingMinutes: Int = 0,
    @SerialName("creditsText")
    val creditsText: String = "",
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
    val healthScore: Int = 0,
    @SerialName("id")
    val id: Int = 0,
    @SerialName("image")
    val image: String = "",
    @SerialName("imageType")
    val imageType: String = "",
    @SerialName("instructions")
    val instructions: String = "",
    @SerialName("lowFodmap")
    val lowFodmap: Boolean = false,
    @SerialName("preparationMinutes")
    val preparationMinutes: Int = 0,
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
    @SerialName("winePairing")
    val winePairing: WinePairingApi = WinePairingApi()
) {
    @Serializable
    internal data class AnalyzedInstructionApi(
        @SerialName("name")
        val name: String = "",
        @SerialName("steps")
        val steps: List<StepApi> = listOf()
    ) {
        @Serializable
        internal data class StepApi(
            @SerialName("equipment")
            val equipment: List<EquipmentApi> = listOf(),
            @SerialName("ingredients")
            val ingredients: List<IngredientApi> = listOf(),
            @SerialName("length")
            val length: LengthApi = LengthApi(),
            @SerialName("number")
            val number: Int = 0,
            @SerialName("step")
            val step: String = ""
        ) {
            @Serializable
            internal data class EquipmentApi(
                @SerialName("id")
                val id: Int = 0,
                @SerialName("image")
                val image: String = "",
                @SerialName("localizedName")
                val localizedName: String = "",
                @SerialName("name")
                val name: String = ""
            )

            @Serializable
            internal data class IngredientApi(
                @SerialName("id")
                val id: Int = 0,
                @SerialName("image")
                val image: String = "",
                @SerialName("localizedName")
                val localizedName: String = "",
                @SerialName("name")
                val name: String = ""
            )

            @Serializable
            internal data class LengthApi(
                @SerialName("number")
                val number: Int = 0,
                @SerialName("unit")
                val unit: String = ""
            )
        }
    }

    @Serializable
    internal data class ExtendedIngredientApi(
        @SerialName("aisle")
        val aisle: String = "",
        @SerialName("amount")
        val amount: Double = 0.0,
        @SerialName("consistency")
        val consistency: String = "",
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
        @SerialName("nameClean")
        val nameClean: String = "",
        @SerialName("original")
        val original: String = "",
        @SerialName("originalName")
        val originalName: String = "",
        @SerialName("unit")
        val unit: String = ""
    ) {
        @Serializable
        internal data class MeasuresApi(
            @SerialName("metric")
            val metric: MetricApi = MetricApi(),
            @SerialName("us")
            val us: UsApi = UsApi()
        ) {
            @Serializable
            internal data class MetricApi(
                @SerialName("amount")
                val amount: Double = 0.0,
                @SerialName("unitLong")
                val unitLong: String = "",
                @SerialName("unitShort")
                val unitShort: String = ""
            )

            @Serializable
            internal data class UsApi(
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
    internal data class WinePairingApi(
        val pairingText: String = ""
    )
}