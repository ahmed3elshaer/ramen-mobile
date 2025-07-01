package com.ramen.recipe.data.storage

import com.ramen.data.Settings
import com.ramen.ingredients.domain.model.Ingredient
import com.ramen.recipe.data.remote.IngredientApi
import com.ramen.recipe.data.model.toData
import kotlinx.serialization.builtins.ListSerializer

internal class IngredientsStorage(val settings: Settings) {

    fun storeIngredient(ingredient: Ingredient) {
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