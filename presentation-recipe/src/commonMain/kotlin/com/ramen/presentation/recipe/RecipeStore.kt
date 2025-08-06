package com.ramen.presentation.recipe

import com.ramen.presentation.Store
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredients
import io.github.aakira.napier.Napier
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class RecipeStore(
    private val recommendRecipeByIngredients: RecommendRecipeByIngredients
) : Store<RecipeState, RecipeAction, RecipeSideEffect>(RecipeState.Initial),
    CoroutineScope by CoroutineScope(Dispatchers.Main) {
    
    private var selectedIngredients: List<String> = emptyList()

    override fun dispatch(action: RecipeAction) {
        val oldState = state.value
        val newState: RecipeState = when (action) {

            is RecipeAction.Data -> {
                if (oldState.progress) {
                    RecipeState(
                        progress = false,
                        searchRecipes = action.searchRecipe
                    )
                } else {
                    launch { sideEffect.emit(RecipeSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            is RecipeAction.Error -> {
                if (oldState.progress) {
                    Napier.e { action.error.stackTraceToString() }
                    launch { sideEffect.emit(RecipeSideEffect.Error(action.error)) }
                    oldState.copy(progress = false)
                } else {
                    launch { sideEffect.emit(RecipeSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            is RecipeAction.RecommendRecipes -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(RecipeSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    launch { recommendIngredient() }
                    oldState.copy(progress = true)
                }
            }
            
            is RecipeAction.UpdateSelectedIngredients -> {
                selectedIngredients = action.ingredients
                oldState
            }
        }

        if (newState != oldState) {
            state.value = newState
        }
    }

    private suspend fun recommendIngredient() {
        try {
            dispatch(RecipeAction.Data(recommendRecipeByIngredients(selectedIngredients)))
        } catch (e: Exception) {
            e.printStackTrace()
            dispatch(RecipeAction.Error(e))
        }
    }
}