package com.ramen.presentation.recipe

import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import kotlin.time.Duration

data class StoreState(
		val progress: Boolean,
		val ingredientAdded: Boolean,
		val ingredients: List<AutocompleteIngredient>
) : State {
	companion object {
		val Initial = StoreState(
				progress = false,
				ingredientAdded = false,
				ingredients = emptyList()
		)
	}
}


sealed class StoreAction : Action {
	data class RecommendIngredient(
			val name: String
	) : StoreAction()

	data class StoreIngredient(
			val autocompleteIngredient: AutocompleteIngredient,
			val expiryDuration: Duration
	) : StoreAction()

	data class Data(val ingredients: List<AutocompleteIngredient>) : StoreAction()
	data class Error(val error: Exception) : StoreAction()
}

sealed class StoreSideEffect : Effect {
	data class Error(val error: Exception) : StoreSideEffect()
}