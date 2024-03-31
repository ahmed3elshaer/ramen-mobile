package com.ramen.recipe.data

import com.ramen.recipe.data.storage.remote.IngredientsRemote
import com.ramen.recipe.data.storage.IngredientsStorage
import com.ramen.ingredients.domain.IngredientsRepository
import com.ramen.recipe.domain.model.AutocompleteIngredient
import com.ramen.ingredients.domain.model.Ingredient
import com.ramen.recipe.data.model.toDomain

internal class IngredientsRepositoryImpl(
    private val remote: IngredientsRemote,
    private val storage: IngredientsStorage
) : IngredientsRepository {

    override suspend fun findIngredient(query: String): List<AutocompleteIngredient> {
        return remote.searchIngredients(query = query)
            .map { it.toDomain() }
    }

    override suspend fun storeIngredient(ingredient: Ingredient) {
        storage.storeIngredient(ingredient)
    }

    override suspend fun retrieveIngredients(): List<Ingredient> {
        return storage.retrieveIngredients()
            .map { it.toDomain() }
    }

    override suspend fun getIngredientInfo(id: Int): Ingredient {
        return remote.getIngredientInfo(id).toDomain()
    }
}