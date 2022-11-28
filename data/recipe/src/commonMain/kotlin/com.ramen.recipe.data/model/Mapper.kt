package com.ramen.recipe.data.model


fun Recipe.toDomain() = com.ramen.recipe.domain.model.Recipe(
    id = this.id,
    image = this.image,
    imageType = this.imageType,
    likes = this.likes,
    missedIngredients = this.missedIngredients.map { it.toDomain() },
    title = this.title,
    unusedIngredients = this.unusedIngredients.map { it.toDomain() },
    usedIngredients = this.usedIngredients.map { it.toDomain() }
)

fun Recipe.Ingredient.toDomain() = com.ramen.recipe.domain.model.Recipe.Ingredient(
    aisle = this.aisle,
    amount = this.amount,
    id = this.id,
    image = this.image,
    name = this.name,
    original = this.original,
    originalName = this.originalName,
    unit = this.unit,
    unitLong = this.unitLong,
    unitShort = this.unitShort
)

