package com.ramen.presentation.store

import com.ramen.ingredients.domain.usecase.RecommendIngredientSearch
import com.ramen.ingredients.domain.usecase.StoreIngredient
import com.ramen.presentation.Store
import com.ramen.presentation.recipe.StoreAction
import com.ramen.presentation.recipe.StoreSideEffect
import com.ramen.presentation.recipe.StoreState
import io.github.aakira.napier.Napier
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class StoreIngredientStore(
		private val recommendIngredientSearch: RecommendIngredientSearch,
		private val storeIngredient: StoreIngredient
) : Store<StoreState, StoreAction, StoreSideEffect>(StoreState.Initial),
		CoroutineScope by CoroutineScope(Dispatchers.Main) {

	override fun dispatch(action: StoreAction) {
		val oldState = state.value
		val newState: StoreState = when (action) {

			is StoreAction.Data -> {
				if (oldState.progress) {
					StoreState(
							progress = false,
							ingredients = action.ingredients,
							ingredientAdded = false
					)
				} else {
					launch { sideEffect.emit(StoreSideEffect.Error(Exception("In progress"))) }
					oldState
				}
			}

			is StoreAction.Error -> {
				if (oldState.progress) {
					Napier.e { action.error.stackTraceToString() }
					launch { sideEffect.emit(StoreSideEffect.Error(action.error)) }
					oldState.copy(progress = false)
				} else {
					launch { sideEffect.emit(StoreSideEffect.Error(Exception("In progress"))) }
					oldState
				}
			}

			is StoreAction.RecommendIngredient -> {
				if (oldState.progress) {
					launch { sideEffect.emit(StoreSideEffect.Error(Exception("In progress"))) }
					oldState
				} else {
					launch { recommendIngredient(action) }
					oldState.copy(progress = true)
				}
			}

			is StoreAction.StoreIngredient -> {
				if (oldState.progress) {
					launch { sideEffect.emit(StoreSideEffect.Error(Exception("In progress"))) }
					oldState.copy(ingredientAdded = true)
				} else {
					launch { storeIngredient(action) }
					oldState.copy(progress = false, ingredientAdded = true)
				}

			}
		}

		if (newState != oldState) {
			state.value = newState
		}
	}

	private suspend fun recommendIngredient(recommendIngredient: StoreAction.RecommendIngredient) {
		try {
			dispatch(StoreAction.Data(recommendIngredientSearch(recommendIngredient.name)))
		} catch (e: Exception) {
			e.printStackTrace()
			dispatch(StoreAction.Error(e))
		}
	}

	private suspend fun storeIngredient(action: StoreAction.StoreIngredient) {
		try {
			storeIngredient(action.autocompleteIngredient, action.expiryDuration)
		} catch (e: Exception) {
			e.printStackTrace()
			dispatch(StoreAction.Error(e))

		}
	}
}