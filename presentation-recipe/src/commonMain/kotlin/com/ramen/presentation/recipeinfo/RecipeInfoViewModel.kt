package com.ramen.presentation.recipeinfo

import androidx.lifecycle.ViewModel
import com.ramen.presentation.MviStore
import com.ramen.presentation.State
import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.recipe.domain.model.Recipe
import com.ramen.recipe.domain.usecase.GetRecipeInfoUseCase
import com.ramen.recipe.domain.usecase.GetRecipeInfoEffect
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

// --- State Definition ---
data class RecipeInfoScreenState(
    val progress: Boolean = false,
    val recipe: Recipe? = null, // Make nullable if it can be absent initially or on error
    val error: String? = null
) : State {
    companion object {
        // Consider if Recipe.Initial is appropriate or if null is better for recipe initially
        val Initial = RecipeInfoScreenState(recipe = Recipe.Initial) 
    }
}

// --- Action Definition ---
sealed interface RecipeInfoScreenAction : Action {
    data class LoadRecipeDetails(val recipeId: String) : RecipeInfoScreenAction
    data class RecipeDetailsLoaded(val recipe: Recipe) : RecipeInfoScreenAction
    data class LoadingFailed(val throwable: Throwable) : RecipeInfoScreenAction
}

// --- Effect Definition (for UI side-effects) ---
sealed interface RecipeInfoScreenEffect : Effect {
    data class ShowErrorSnackbar(val message: String) : RecipeInfoScreenEffect
}

// --- Reducer ---
private fun recipeInfoReducer(
    currentState: RecipeInfoScreenState,
    action: RecipeInfoScreenAction
): RecipeInfoScreenState {
    return when (action) {
        is RecipeInfoScreenAction.LoadRecipeDetails -> {
            currentState.copy(progress = true, error = null, recipe = null) // Clear previous recipe while loading new one
        }
        is RecipeInfoScreenAction.RecipeDetailsLoaded -> {
            currentState.copy(progress = false, recipe = action.recipe, error = null)
        }
        is RecipeInfoScreenAction.LoadingFailed -> {
            currentState.copy(progress = false, error = action.throwable.message ?: "Unknown error", recipe = null)
        }
    }
}

// --- ViewModel ---
class RecipeInfoViewModel(
    private val getRecipeInfoUseCase: GetRecipeInfoUseCase,
    private val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main)
) : ViewModel(viewModelScope = coroutineScope){
    private val store = MviStore<RecipeInfoScreenState, RecipeInfoScreenAction, RecipeInfoScreenEffect>(
        initialState = RecipeInfoScreenState.Initial,
        reducer = ::recipeInfoReducer,
        effectHandler = ::recipeInfoEffectHandler,
        coroutineScope = coroutineScope
    )

    val viewState = store.state
    val viewEffects = store.effects

    fun dispatch(action: RecipeInfoScreenAction) {
        store.dispatch(action)
    }

    // --- Effect Handler ---
    private suspend fun recipeInfoEffectHandler(
        action: RecipeInfoScreenAction,
        newState: RecipeInfoScreenState,
        emitUiEffect: suspend (RecipeInfoScreenEffect) -> Unit
    ) {
        when (action) {
            is RecipeInfoScreenAction.LoadRecipeDetails -> {
                when (val result = getRecipeInfoUseCase(action.recipeId)) {
                    is GetRecipeInfoEffect.Success -> {
                        dispatch(RecipeInfoScreenAction.RecipeDetailsLoaded(result.recipe))
                    }
                    is GetRecipeInfoEffect.Failure -> {
                        dispatch(RecipeInfoScreenAction.LoadingFailed(result.error))
                        emitUiEffect(RecipeInfoScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to load recipe details"))
                    }
                    is GetRecipeInfoEffect.Loading -> {
                        // Optional: Can be handled by reducer if action also goes to reducer
                        // Or handle as a specific UI effect if needed.
                        // For now, progress=true in reducer covers this.
                    }
                }
            }
            else -> Unit // Other actions are handled by reducer or don't trigger new effects here
        }
    }
} 