package com.ramen.presentation.store

import androidx.lifecycle.ViewModel
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.presentation.MviStore
import com.ramen.presentation.State
import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.recipe.domain.usecase.RecommendIngredientSearchEffect
import com.ramen.recipe.domain.usecase.RecommendIngredientSearchUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientEffect
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlin.time.Duration

// --- State Definition ---
data class StoreIngredientScreenState(
    val progress: Boolean = false,
    val searchResults: List<AutocompleteIngredient> = emptyList(),
    val ingredientSuccessfullyAdded: Boolean = false,
    val error: String? = null
) : State {
    companion object {
        val Initial = StoreIngredientScreenState()
    }
}

// --- Action Definition ---
sealed interface StoreIngredientScreenAction : Action {
    data class SearchIngredients(val query: String) : StoreIngredientScreenAction
    data class ConfirmStoreIngredient(
        val ingredient: AutocompleteIngredient,
        val expiryDuration: Duration
    ) : StoreIngredientScreenAction
    object ClearConfirmation : StoreIngredientScreenAction // To reset ingredientSuccessfullyAdded

    // Internal Actions
    data class SearchResultsLoaded(val ingredients: List<AutocompleteIngredient>) : StoreIngredientScreenAction
    object IngredientStored : StoreIngredientScreenAction
    data class OperationFailed(val throwable: Throwable) : StoreIngredientScreenAction
}

// --- Effect Definition (for UI side-effects) ---
sealed interface StoreIngredientScreenEffect : Effect {
    data class ShowErrorSnackbar(val message: String) : StoreIngredientScreenEffect
    object NotifyIngredientStored: StoreIngredientScreenEffect // e.g. for a toast or navigation
}

// --- Reducer ---
private fun storeIngredientReducer(
    currentState: StoreIngredientScreenState,
    action: StoreIngredientScreenAction
): StoreIngredientScreenState {
    return when (action) {
        is StoreIngredientScreenAction.SearchIngredients -> {
            currentState.copy(progress = true, ingredientSuccessfullyAdded = false, error = null)
        }
        is StoreIngredientScreenAction.ConfirmStoreIngredient -> {
            currentState.copy(progress = true, ingredientSuccessfullyAdded = false, error = null) 
        }
        is StoreIngredientScreenAction.SearchResultsLoaded -> {
            currentState.copy(progress = false, searchResults = action.ingredients)
        }
        is StoreIngredientScreenAction.IngredientStored -> {
            currentState.copy(progress = false, ingredientSuccessfullyAdded = true, searchResults = emptyList()) // Clear search results
        }
        is StoreIngredientScreenAction.OperationFailed -> {
            currentState.copy(progress = false, error = action.throwable.message ?: "Unknown error")
        }
        is StoreIngredientScreenAction.ClearConfirmation -> {
            currentState.copy(ingredientSuccessfullyAdded = false)
        }
    }
}

// --- ViewModel ---
class StoreIngredientViewModel(
    private val recommendIngredientSearchUseCase: RecommendIngredientSearchUseCase,
    private val storeIngredientUseCase: StoreIngredientUseCase,
    private val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) : ViewModel(viewModelScope = coroutineScope){
    private val store = MviStore<StoreIngredientScreenState, StoreIngredientScreenAction, StoreIngredientScreenEffect>(
        initialState = StoreIngredientScreenState.Initial,
        reducer = ::storeIngredientReducer,
        effectHandler = ::storeIngredientEffectHandler,
        coroutineScope = coroutineScope
    )

    val viewState = store.state
    val viewEffects = store.effects

    fun dispatch(action: StoreIngredientScreenAction) {
        store.dispatch(action)
    }

    // --- Effect Handler ---
    private suspend fun storeIngredientEffectHandler(
        action: StoreIngredientScreenAction,
        newState: StoreIngredientScreenState,
        emitUiEffect: suspend (StoreIngredientScreenEffect) -> Unit
    ) {
        when (action) {
            is StoreIngredientScreenAction.SearchIngredients -> {
                if (action.query.isBlank()) { // Optional: handle blank query explicitly
                    dispatch(StoreIngredientScreenAction.SearchResultsLoaded(emptyList()))
                    return
                }
                when (val result = recommendIngredientSearchUseCase(action.query)) {
                    is RecommendIngredientSearchEffect.Success -> {
                        dispatch(StoreIngredientScreenAction.SearchResultsLoaded(result.ingredients))
                    }
                    is RecommendIngredientSearchEffect.Failure -> {
                        dispatch(StoreIngredientScreenAction.OperationFailed(result.error))
                        emitUiEffect(StoreIngredientScreenEffect.ShowErrorSnackbar(result.error.message ?: "Search failed"))
                    }
                }
            }
            is StoreIngredientScreenAction.ConfirmStoreIngredient -> {
                when (val result = storeIngredientUseCase(action.ingredient, action.expiryDuration)) {
                    is StoreIngredientEffect.Success -> {
                        dispatch(StoreIngredientScreenAction.IngredientStored)
                        emitUiEffect(StoreIngredientScreenEffect.NotifyIngredientStored)
                    }
                    is StoreIngredientEffect.Failure -> {
                        dispatch(StoreIngredientScreenAction.OperationFailed(result.error))
                        emitUiEffect(StoreIngredientScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to store ingredient"))
                    }
                }
            }
            else -> Unit
        }
    }
} 