package com.ramen.ingredient.data.model

import com.ramen.ingredient.data.model.Ingredient

fun Ingredient.toDomain() = com.ramen.ingredients.domain.model.Ingredient(
    aisle = this.aisle,
    amount = this.amount,
    id = this.id,
    storeDate = this.storeDate,
    expiryDate = this.expiryDate,
    image = this.image,
    name = this.name,
    unit = this.unit,
    unitLong = this.unitLong,
    unitShort = this.unitShort
)

fun com.ramen.ingredients.domain.model.Ingredient.toData() = Ingredient(
    aisle = this.aisle,
    amount = this.amount,
    id = this.id,
    storeDate = this.storeDate,
    expiryDate = this.expiryDate,
    image = this.image,
    name = this.name,
    unit = this.unit,
    unitLong = this.unitLong,
    unitShort = this.unitShort
)

fun AutocompleteIngredient.toDomain() = com.ramen.ingredients.domain.model.AutocompleteIngredient(
    id = this.id,
    name = this.name,
    image = this.image

)