package com.ramen.presentation.monitor

import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.recipe.domain.model.Ingredient
import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import kotlin.time.Duration

data class MonitorState(
		val progress: Boolean,
		val ingredients: List<Ingredient>
) : State {
	companion object {
		val Initial = MonitorState(
				progress = false,
				ingredients = emptyList()
		)
	}
}


sealed class MonitorAction : Action {
	object Refresh : MonitorAction()
	data class StoreIngredient(
			val autocompleteIngredient: AutocompleteIngredient,
			val expiryDuration: Duration
	) : MonitorAction()

	data class Data(val ingredients: List<Ingredient>) : MonitorAction()
	data class Error(val error: Exception) : MonitorAction()
}

sealed class MonitorSideEffect : Effect {
	data class Error(val error: Exception) : MonitorSideEffect()
	data object Initial : MonitorSideEffect()
}