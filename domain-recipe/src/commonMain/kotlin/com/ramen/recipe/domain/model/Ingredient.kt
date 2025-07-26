@file:Suppress("unused")

package com.ramen.recipe.domain.model
import kotlin.time.Clock
import kotlin.time.Duration
import kotlin.time.ExperimentalTime
import kotlin.time.Instant

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
    @OptIn(ExperimentalTime::class)
    fun durationUntilExpiry(): String {
        val inWholeDays =
            (kotlin.time.Instant.fromEpochMilliseconds(expirationAt) - kotlin.time.Clock.System.now())
        println(inWholeDays)
        return inWholeDays.inWholeDays.toString()
    }

    fun totalDurationInDays(): String {
        println(expiryDuration)
        println(expiryDuration.inWholeDays.toString())
        return expiryDuration.inWholeDays.toString()
    }

    @OptIn(ExperimentalTime::class)
    fun expiryProgress(): Double {
        val totalDaysDuration = expiryDuration.inWholeDays
        val durationUntilExpiry =
            (Instant.fromEpochMilliseconds(expirationAt) - Clock.System.now()).inWholeDays
        return durationUntilExpiry.toDouble() / totalDaysDuration.toDouble()
    }

    // New utility methods for UI
    
    /**
     * Gets the main category from categoryPath or falls back to aisle
     */
    fun getCategory(): String {
        return when {
            categoryPath.isNotEmpty() -> categoryPath.last().uppercase()
            aisle.isNotBlank() -> aisle.uppercase()
            else -> getDefaultCategory()
        }
    }
    
    /**
     * Determines the status text based on remaining days
     */
    @OptIn(ExperimentalTime::class)
    fun getStatusText(): String {
        val remainingDays = (Instant.fromEpochMilliseconds(expirationAt) - Clock.System.now()).inWholeDays
        return when {
            remainingDays <= 0 -> "Dispose now"
            remainingDays <= 1 -> "Use soon"
            else -> "Fresh & ready"
        }
    }
    
    /**
     * Determines the expiry state for UI styling
     */
    @OptIn(ExperimentalTime::class) 
    fun getExpiryState(): ExpiryState {
        val remainingDays = (Instant.fromEpochMilliseconds(expirationAt) - Clock.System.now()).inWholeDays
        return when {
            remainingDays <= 0 -> ExpiryState.EXPIRED
            remainingDays <= 1 -> ExpiryState.EXPIRING_SOON
            else -> ExpiryState.FRESH
        }
    }
    
    /**
     * Gets remaining days as a formatted string with suffix
     */
    @OptIn(ExperimentalTime::class)
    fun getDaysRemainingFormatted(): String {
        val remainingDays = (Instant.fromEpochMilliseconds(expirationAt) - Clock.System.now()).inWholeDays
        return when {
            remainingDays <= 0 -> "EXPIRED"
            remainingDays == 1L -> "1d"
            else -> "${remainingDays}d"
        }
    }
    
    /**
     * Gets total days as a formatted string
     */
    fun getTotalDaysFormatted(): String {
        val totalDays = expiryDuration.inWholeDays
        return "${totalDays}d total"
    }
    
    private fun getDefaultCategory(): String {
        // Basic categorization based on ingredient name
        val nameLower = name.lowercase()
        return when {
            nameLower.contains("spinach") || nameLower.contains("lettuce") || 
            nameLower.contains("kale") || nameLower.contains("arugula") -> "LEAFY"
            nameLower.contains("carrot") || nameLower.contains("potato") || 
            nameLower.contains("onion") || nameLower.contains("tomato") -> "VEGETABLE"
            nameLower.contains("yogurt") || nameLower.contains("milk") || 
            nameLower.contains("cheese") || nameLower.contains("cream") -> "DAIRY"
            nameLower.contains("bread") || nameLower.contains("rice") || 
            nameLower.contains("pasta") || nameLower.contains("flour") -> "GRAIN"
            nameLower.contains("chicken") || nameLower.contains("beef") || 
            nameLower.contains("fish") || nameLower.contains("pork") -> "PROTEIN"
            else -> "OTHER"
        }
    }

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

enum class ExpiryState {
    FRESH,
    EXPIRING_SOON, 
    EXPIRED
}









