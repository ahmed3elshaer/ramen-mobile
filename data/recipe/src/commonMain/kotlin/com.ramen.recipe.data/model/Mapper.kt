package com.ramen.recipe.data.model

import com.ramen.recipe.domain.model.Recipe
import com.ramen.recipe.domain.model.SearchRecipe


fun SearchRecipeApi.toDomain() = SearchRecipe(id = this.id,
    image = this.image,
    imageType = this.imageType,
    likes = this.likes,
    missedIngredients = this.missedIngredients.map { it.toDomain() },
    title = this.title,
    unusedIngredients = this.unusedIngredients.map { it.toDomain() },
    usedIngredients = this.usedIngredients.map { it.toDomain() })

fun SearchRecipeApi.Ingredient.toDomain() = SearchRecipe.Ingredient(
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

fun RecipeApi.toDomain() = Recipe(
    aggregateLikes = this.aggregateLikes,
    analyzedInstructions = this.analyzedInstructions,
    cheap = this.cheap,
    creditsText = this.creditsText,
    cuisines = this.cuisines,
    dairyFree = this.dairyFree,
    diets = this.diets,
    dishTypes = this.dishTypes,
    extendedIngredients = this.extendedIngredients.toDomain(),
    gaps = this.gaps,
    glutenFree = this.glutenFree,
    healthScore = this.healthScore,
    id = this.id,
    image = this.image,
    imageType = this.imageType,
    instructions = this.instructions,
    ketogenic = this.ketogenic,
    license = this.license,
    lowFodmap = this.lowFodmap,
    occasions = this.occasions,
    pricePerServing = this.pricePerServing,
    readyInMinutes = this.readyInMinutes,
    servings = this.servings,
    sourceName = this.sourceName,
    sourceUrl = this.sourceUrl,
    spoonacularScore = this.spoonacularScore,
    spoonacularSourceUrl = this.spoonacularSourceUrl,
    summary = this.summary,
    sustainable = this.sustainable,
    title = this.title,
    vegan = this.vegan,
    vegetarian = this.vegetarian,
    veryHealthy = this.veryHealthy,
    veryPopular = this.veryPopular,
    weightWatcherSmartPoints = this.weightWatcherSmartPoints,
    whole30 = this.whole30,
    winePairing = this.winePairing.toDomain()

)

fun RecipeApi.WinePairingApi.toDomain() = Recipe.WinePairing(pairedWines = this.pairedWines,
    pairingText = this.pairingText,
    productMatches = this.productMatches.map { it.toDomain() }

)

fun RecipeApi.WinePairingApi.ProductMatcheApi.toDomain() = Recipe.WinePairing.ProductMatch(
    averageRating = this.averageRating,
    description = description,
    id = id,
    imageUrl = imageUrl,
    link = link,
    price = price,
    ratingCount = ratingCount,
    score = score,
    title = title

)

fun List<RecipeApi.ExtendedIngredientApi>.toDomain() = map { it.toDomain() }

fun RecipeApi.ExtendedIngredientApi.toDomain() = Recipe.ExtendedIngredient(
    aisle = aisle,
    amount = amount,
    consistency = consitency,
    id = id,
    image = image,
    measures = measures.toDomain(),
    meta = this.meta,
    name = this.name,
    original = this.original,
    originalName = this.originalName,
    unit = this.unit

)

fun RecipeApi.ExtendedIngredientApi.MeasuresApi.toDomain() = Recipe.ExtendedIngredient.Measures(
    metric = this.metric.toDomain(), us = this.us.toDomain()
)

fun RecipeApi.ExtendedIngredientApi.MeasuresApi.MetricApi.toDomain() =
    Recipe.ExtendedIngredient.Measures.Metric(
        amount = amount, unitLong = unitLong, unitShort = unitShort

    )

fun RecipeApi.ExtendedIngredientApi.MeasuresApi.UsApi.toDomain() =
    Recipe.ExtendedIngredient.Measures.Us(
        amount = amount, unitLong = unitLong, unitShort = unitShort
    )

