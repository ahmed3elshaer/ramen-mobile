package com.ramen.recipe.data.model

import com.ramen.recipe.data.remote.AutocompleteIngredientApi
import com.ramen.recipe.data.remote.IngredientApi
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

internal fun RecipeApi.toDomain() = Recipe(
		aggregateLikes = this.aggregateLikes,
		analyzedInstructions = this.analyzedInstructions.map { it.toDomain() },
		cheap = this.cheap,
		creditsText = this.creditsText,
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
		lowFodmap = this.lowFodmap,
		pricePerServing = this.pricePerServing,
		readyInMinutes = this.readyInMinutes,
		servings = this.servings,
		sourceName = this.sourceName,
		sourceUrl = this.sourceUrl,
		spoonacularSourceUrl = this.spoonacularSourceUrl,
		summary = this.summary,
		sustainable = this.sustainable,
		title = this.title,
		vegan = this.vegan,
		vegetarian = this.vegetarian,
		veryHealthy = this.veryHealthy,
		veryPopular = this.veryPopular,
		weightWatcherSmartPoints = this.weightWatcherSmartPoints,
		winePairing = this.winePairing?.toDomain() ?: Recipe.WinePairing()

)

internal fun RecipeApi.AnalyzedInstructionApi.toDomain() = Recipe.AnalyzedInstruction(
		name = this.name,
		steps = this.steps.map { it.toDomain() }
)

internal fun RecipeApi.AnalyzedInstructionApi.StepApi.toDomain() = Recipe.AnalyzedInstruction.Step(
		equipment = this.equipment.map { it.toDomain() },
		ingredients = this.ingredients.map { it.toDomain() },
		length = this.length?.toDomain() ?: Recipe.AnalyzedInstruction.Step.Length(),
		number = this.number,
		step = this.step
)

internal fun RecipeApi.AnalyzedInstructionApi.StepApi.EquipmentApi.toDomain() =
		Recipe.AnalyzedInstruction.Step.Equipment(
				id = this.id,
				image = this.image,
				name = this.name,
				localizedName = this.localizedName,
		)

internal fun RecipeApi.AnalyzedInstructionApi.StepApi.IngredientApi.toDomain() =
		Recipe.AnalyzedInstruction.Step.Ingredient(
				id = this.id,
				image = this.image,
				name = this.name,
				localizedName = this.localizedName
		)

internal fun RecipeApi.AnalyzedInstructionApi.StepApi.LengthApi.toDomain() =
		Recipe.AnalyzedInstruction.Step.Length(
				number = this.number,
				unit = this.unit
		)

internal fun RecipeApi.WinePairingApi.toDomain() = Recipe.WinePairing(
		pairingText = this.pairingText,
)

internal fun List<RecipeApi.ExtendedIngredientApi>.toDomain() = map { it.toDomain() }

internal fun RecipeApi.ExtendedIngredientApi.toDomain() = Recipe.ExtendedIngredient(
		aisle = aisle,
		amount = amount,
		consistency = consistency,
		id = id,
		image = image,
		measures = measures.toDomain(),
		meta = this.meta,
		name = this.name,
		original = this.original,
		originalName = this.originalName,
		unit = this.unit

)

internal fun RecipeApi.ExtendedIngredientApi.MeasuresApi.toDomain() =
		Recipe.ExtendedIngredient.Measures(
				metric = this.metric.toDomain(), us = this.us.toDomain()
		)

internal fun RecipeApi.ExtendedIngredientApi.MeasuresApi.MetricApi.toDomain() =
		Recipe.ExtendedIngredient.Measures.Metric(
				amount = amount, unitLong = unitLong, unitShort = unitShort

		)

internal fun RecipeApi.ExtendedIngredientApi.MeasuresApi.UsApi.toDomain() =
		Recipe.ExtendedIngredient.Measures.Us(
				amount = amount, unitLong = unitLong, unitShort = unitShort
		)


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
