package com.ramen.ingredient.data.storage

import com.ramen.data.Settings
import com.ramen.ingredient.data.model.IngredientApi
import com.ramen.recipe.data.model.toData
import kotlinx.serialization.builtins.ListSerializer

internal class IngredientsStorage(val settings: Settings) {

    fun storeIngredient(ingredient: com.ramen.ingredients.domain.model.Ingredient) {
        val mutableList = retrieveIngredients()
            .toMutableList().apply {
                add(ingredient.toData())
            }

        settings.putSetting(
            INGREDIENTS,
            mutableList,
            ListSerializer(IngredientApi.serializer())
        )
    }

    fun retrieveIngredients(): List<IngredientApi> {
        return settings.getSetting(
            INGREDIENTS,
            ListSerializer(IngredientApi.serializer())
        ) ?: emptyList()
    }

    companion object {
        private const val INGREDIENTS = "ingredients-storage"
    }

}