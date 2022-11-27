package com.ramen.recipe.data.model

import com.ramen.ingredient.data.model.toDomain

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

