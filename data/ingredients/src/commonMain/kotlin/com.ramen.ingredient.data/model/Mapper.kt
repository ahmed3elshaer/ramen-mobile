package com.ramen.ingredient.data.model


fun IngredientApi.toDomain() = com.ramen.ingredients.domain.model.Ingredient(
    id = this.id,
    image = this.image,
    name = this.name,
    aisle = this.aisle,
    amount = this.amount,
    original = this.original,
    originalName = this.originalName,
    possibleUnits = this.possibleUnits,
    shoppingListUnits = this.shoppingListUnits,
    unit = this.unit,
    unitLong = this.unitLong,
    unitShort = this.unitShort,
    categoryPath = this.categoryPath,
    consistency = this.consistency,
    storedAt = this.storedAt,
    expirationAt = this.expirationAt,
    expiryDuration = this.expiryDuration,
    estimatedCost = com.ramen.ingredients.domain.model.Ingredient.EstimatedCost(
        unit = this.estimatedCost.unit,
        value = this.estimatedCost.value
    ),
    nutrition = com.ramen.ingredients.domain.model.Ingredient.Nutrition(
        caloricBreakdown = com.ramen.ingredients.domain.model.Ingredient.Nutrition.CaloricBreakdown(
            percentCarbs = this.nutrition.caloricBreakdown.percentCarbs,
            percentFat = this.nutrition.caloricBreakdown.percentFat,
            percentProtein = this.nutrition.caloricBreakdown.percentProtein
        ),
        flavonoids = this.nutrition.flavonoids.map {
            com.ramen.ingredients.domain.model.Ingredient.Nutrition.Flavonoid(
                amount = it.amount, name = it.name, unit = it.unit
            )
        },
        nutrients = this.nutrition.nutrients.map {
            com.ramen.ingredients.domain.model.Ingredient.Nutrition.Nutrient(
                amount = it.amount,
                name = it.name,
                percentOfDailyNeeds = it.percentOfDailyNeeds,
                unit = it.unit
            )
        },
        properties = this.nutrition.properties.map {
            com.ramen.ingredients.domain.model.Ingredient.Nutrition.Property(
                amount = it.amount,
                name = it.name,
                unit = it.unit
            )
        },
        weightPerServing = com.ramen.ingredients.domain.model.Ingredient.WeightPerServing(
            amount = this.nutrition.weightPerServing.amount,
            unit = this.nutrition.weightPerServing.unit
        )
    )
)

fun com.ramen.ingredients.domain.model.Ingredient.toData() = IngredientApi(
    id = this.id,
    image = this.image,
    name = this.name,
    aisle = this.aisle,
    amount = this.amount,
    original = this.original,
    originalName = this.originalName,
    possibleUnits = this.possibleUnits,
    shoppingListUnits = this.shoppingListUnits,
    unit = this.unit,
    unitLong = this.unitLong,
    unitShort = this.unitShort,
    categoryPath = this.categoryPath,
    consistency = this.consistency,
    storedAt = this.storedAt,
    expirationAt = this.expirationAt,
    expiryDuration = this.expiryDuration,
    estimatedCost = IngredientApi.EstimatedCost(
        unit = this.estimatedCost.unit,
        value = this.estimatedCost.value
    ),
    nutrition = IngredientApi.Nutrition(
        caloricBreakdown = IngredientApi.Nutrition.CaloricBreakdown(
            percentCarbs = this.nutrition.caloricBreakdown.percentCarbs,
            percentFat = this.nutrition.caloricBreakdown.percentFat,
            percentProtein = this.nutrition.caloricBreakdown.percentProtein
        ),
        flavonoids = this.nutrition.flavonoids.map {
            IngredientApi.Nutrition.Flavonoid(
                amount = it.amount, name = it.name, unit = it.unit
            )
        },
        nutrients = this.nutrition.nutrients.map {
            IngredientApi.Nutrition.Nutrient(
                amount = it.amount,
                name = it.name,
                percentOfDailyNeeds = it.percentOfDailyNeeds,
                unit = it.unit
            )
        },
        properties = this.nutrition.properties.map {
            IngredientApi.Nutrition.Property(
                amount = it.amount,
                name = it.name,
                unit = it.unit
            )
        },
        weightPerServing = IngredientApi.Nutrition.WeightPerServing(
            amount = this.nutrition.weightPerServing.amount,
            unit = this.nutrition.weightPerServing.unit
        )
    )
)

fun AutocompleteIngredientApi.toDomain() = com.ramen.ingredients.domain.model.AutocompleteIngredient(
    id = this.id,
    name = this.name,
    image = this.image

)