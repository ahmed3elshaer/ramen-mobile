package com.ramen.presentation.recipe

import androidx.lifecycle.ViewModel
import com.ramen.presentation.MviStore
import com.ramen.presentation.State // Base State
import com.ramen.presentation.Action // Base Action
import com.ramen.presentation.Effect // Base Effect
import com.ramen.recipe.domain.model.SearchRecipe
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredientsUseCase
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredientsEffect
import com.ramen.recipe.domain.usecase.RetrieveIngredientsUseCase
import com.ramen.recipe.domain.usecase.RetrieveIngredientsEffect
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

// --- State Definition ---
data class RecipeScreenState(
    val progress: Boolean = false,
    val searchRecipes: List<SearchRecipe> = emptyList(),
    val error: String? = null // For displaying user-facing errors
) : State {
    companion object {
        val Initial = RecipeScreenState()
    }
}

// --- Action Definition ---
sealed interface RecipeScreenAction : Action {
    object LoadInitialRecipes : RecipeScreenAction // Renamed from RecommendRecipes for clarity
    data class IngredientsLoaded(val ingredientNames: List<String>) : RecipeScreenAction // Internal action
    data class RecipesLoaded(val recipes: List<SearchRecipe>) : RecipeScreenAction
    data class LoadingFailed(val throwable: Throwable) : RecipeScreenAction
}

// --- Effect Definition (for UI side-effects like navigation, toasts) ---
sealed interface RecipeScreenEffect : Effect {
    data class ShowErrorSnackbar(val message: String) : RecipeScreenEffect
}

// --- Reducer ---
private fun recipeReducer(
    currentState: RecipeScreenState,
    action: RecipeScreenAction
): RecipeScreenState {
    return when (action) {
        is RecipeScreenAction.LoadInitialRecipes -> {
            currentState.copy(progress = true, error = null)
        }
        is RecipeScreenAction.IngredientsLoaded -> {
            // Still in progress, waiting for recipes
            currentState.copy(progress = true, error = null)
        }
        is RecipeScreenAction.RecipesLoaded -> {
            currentState.copy(progress = false, searchRecipes = action.recipes, error = null)
        }
        is RecipeScreenAction.LoadingFailed -> {
            currentState.copy(progress = false, error = action.throwable.message ?: "Unknown error")
        }
    }
}

// --- ViewModel ---
class RecipeViewModel(
    private val retrieveIngredientsUseCase: RetrieveIngredientsUseCase,
    private val recommendRecipeByIngredientsUseCase: RecommendRecipeByIngredientsUseCase,
    private val coroutineScope: CoroutineScope = CoroutineScope(Dispatchers.Main) // Provide a default scope
) : ViewModel(viewModelScope = coroutineScope){
    private val store = MviStore<RecipeScreenState, RecipeScreenAction, RecipeScreenEffect>(
        initialState = RecipeScreenState.Initial,
        reducer = ::recipeReducer,
        effectHandler = ::recipeEffectHandler,
        coroutineScope = coroutineScope
    )

    val viewState = store.state
    val viewEffects = store.effects

    fun dispatch(action: RecipeScreenAction) {
        store.dispatch(action)
    }

    // --- Effect Handler ---
    // NOTE: The effectHandler in MviStore is `suspend (A, S, (E) -> Unit) -> Unit`
    // The (E) -> Unit is for emitting UI effects.
    // For use case results that should become new actions, we'll dispatch them back to the store.
    private suspend fun recipeEffectHandler(
        action: RecipeScreenAction,
        newState: RecipeScreenState, // The state *after* the reducer has processed the action
        emitUiEffect: suspend (RecipeScreenEffect) -> Unit
    ) {
        when (action) {
            is RecipeScreenAction.LoadInitialRecipes -> {
                // Step 1: Retrieve ingredients
                when (val result = retrieveIngredientsUseCase()) {
                    is RetrieveIngredientsEffect.Success -> {
                        // Step 2: Dispatch new action with loaded ingredient names
                        val ingredientNames = result.ingredients.map { it.name }
                        dispatch(RecipeScreenAction.IngredientsLoaded(ingredientNames))
                    }
                    is RetrieveIngredientsEffect.Failure -> {
                        dispatch(RecipeScreenAction.LoadingFailed(result.error))
                        emitUiEffect(RecipeScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to load ingredients"))
                    }
                }
            }
            is RecipeScreenAction.IngredientsLoaded -> {
                // Step 3: Recommend recipes with the loaded ingredient names
                when (val result = recommendRecipeByIngredientsUseCase(action.ingredientNames)) {
                    is RecommendRecipeByIngredientsEffect.Success -> {
                        dispatch(RecipeScreenAction.RecipesLoaded(result.recipes))
                    }
                    is RecommendRecipeByIngredientsEffect.Failure -> {
                        dispatch(RecipeScreenAction.LoadingFailed(result.error))
                        emitUiEffect(RecipeScreenEffect.ShowErrorSnackbar(result.error.message ?: "Failed to recommend recipes"))
                    }
                }
            }
            else -> Unit // Other actions don't have side effects handled here
        }
    }
} 