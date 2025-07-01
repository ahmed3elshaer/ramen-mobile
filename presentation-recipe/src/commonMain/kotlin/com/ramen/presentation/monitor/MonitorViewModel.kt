package com.ramen.presentation.monitor

import androidx.lifecycle.ViewModel
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.ingredients.domain.model.Ingredient
import com.ramen.presentation.MviStore
import com.ramen.presentation.State
import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.recipe.domain.usecase.RetrieveIngredientsUseCase
import com.ramen.recipe.domain.usecase.RetrieveIngredientsEffect
import com.ramen.recipe.domain.usecase.StoreIngredientUseCase
import com.ramen.recipe.domain.usecase.StoreIngredientEffect
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlin.time.Duration

// --- State Definition ---
data class MonitorScreenState(
    val progress: Boolean = false,
    val ingredients: List<Ingredient> = emptyList(),
    val error: String? = null
) : State {
    companion object {
        val Initial = MonitorScreenState()
    }
}

// --- Action Definition ---
sealed interface MonitorScreenAction : Action {
    object LoadIngredients : MonitorScreenAction
    data class StoreNewIngredient(
        val autocompleteIngredient: AutocompleteIngredient,
        val expiryDuration: Duration
    ) : MonitorScreenAction

    // Internal actions triggered by effect handler
    data class IngredientsLoaded(val ingredients: List<Ingredient>) : MonitorScreenAction
    object IngredientStoredSuccessfully : MonitorScreenAction // Could trigger a refresh
    data class OperationFailed(val throwable: Throwable) : MonitorScreenAction
}

// --- Effect Definition (for UI side-effects) ---
sealed interface MonitorScreenEffect : Effect {
    data class ShowErrorSnackbar(val message: String) : MonitorScreenEffect
    // object IngredientSuccessfullyStoredMessage: MonitorScreenEffect // Optional: if you want a specific message
}

// --- Reducer ---
private fun monitorReducer(
    currentState: MonitorScreenState,
    action: MonitorScreenAction
): MonitorScreenState {
    return when (action) {
        is MonitorScreenAction.LoadIngredients -> {
            currentState.copy(progress = true, error = null)
        }
        is MonitorScreenAction.StoreNewIngredient -> {
            currentState.copy(progress = true, error = null) // Indicate processing
        }
        is MonitorScreenAction.IngredientsLoaded -> {
            currentState.copy(progress = false, ingredients = action.ingredients, error = null)
        }
        is MonitorScreenAction.IngredientStoredSuccessfully -> {
            // State indicates progress true because a refresh (LoadIngredients) will be triggered
            currentState.copy(progress = true, error = null) 
        }
        is MonitorScreenAction.OperationFailed -> {
            currentState.copy(progress = false, error = action.throwable.message ?: "Unknown error")
        }
    }
}

// --- ViewModel ---
class MonitorViewModel(
    private val retrieveIngredientsUseCase: RetrieveIngredientsUseCase,
    private val storeIngredientUseCase: StoreIngredientUseCase,
    private val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) : ViewModel(viewModelScope = coroutineScope){
    private val store = MviStore<MonitorScreenState, MonitorScreenAction, MonitorScreenEffect>(
        initialState = MonitorScreenState.Initial,
        reducer = ::monitorReducer,
        effectHandler = ::monitorEffectHandler,
        coroutineScope = coroutineScope
    )

    val viewState = store.state
    val viewEffects = store.effects

    fun dispatch(action: MonitorScreenAction) {
        store.dispatch(action)
    }

    // --- Effect Handler ---
    private suspend fun monitorEffectHandler(
        action: MonitorScreenAction,
        prevState : MonitorScreenState,
        emitUiEffect: suspend (MonitorScreenEffect) -> Unit
    ) {
        when (action) {
            is MonitorScreenAction.LoadIngredients -> {
                when (val result = retrieveIngredientsUseCase()) {
                    is RetrieveIngredientsEffect.Success -> {
                        dispatch(MonitorScreenAction.IngredientsLoaded(result.ingredients))
                    }
                    is RetrieveIngredientsEffect.Failure -> {
                        dispatch(MonitorScreenAction.OperationFailed(result.error))
                        emitUiEffect(MonitorScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to load ingredients"))
                    }
                }
            }
            is MonitorScreenAction.StoreNewIngredient -> {
                when (val result = storeIngredientUseCase(action.autocompleteIngredient, action.expiryDuration)) {
                    is StoreIngredientEffect.Success -> {
                        // After successfully storing, dispatch an action that will trigger a refresh
                        dispatch(MonitorScreenAction.IngredientStoredSuccessfully)
                    }
                    is StoreIngredientEffect.Failure -> {
                        dispatch(MonitorScreenAction.OperationFailed(result.error))
                        emitUiEffect(MonitorScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to store ingredient"))
                    }
                }
            }
            is MonitorScreenAction.IngredientStoredSuccessfully -> {
                // Trigger a refresh of the ingredient list
                dispatch(MonitorScreenAction.LoadIngredients)
            }
            else -> Unit // Other actions (IngredientsLoaded, OperationFailed) are handled by reducer or don't trigger new effects here
        }
    }
} 