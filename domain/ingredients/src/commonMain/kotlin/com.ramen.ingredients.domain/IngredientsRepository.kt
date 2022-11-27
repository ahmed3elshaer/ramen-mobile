package com.ramen.ingredients.domain

interface IngredientsRepository {
    fun findIngredient(query: String): List<Ingredients>
}