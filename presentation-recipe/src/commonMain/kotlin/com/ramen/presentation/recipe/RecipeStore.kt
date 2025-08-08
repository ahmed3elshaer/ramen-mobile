package com.ramen.presentation.recipe

import com.ramen.presentation.Store
import com.ramen.recipe.domain.usecase.RecommendRecipeByIngredients
import com.ramen.recipe.domain.usecase.RetrieveIngredients
import io.github.aakira.napier.Napier
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class RecipeStore(
    private val recommendRecipeByIngredients: RecommendRecipeByIngredients,
    private val retrieveIngredients: RetrieveIngredients
) : Store<RecipeState, RecipeAction, RecipeSideEffect>(RecipeState.Initial),
    CoroutineScope by CoroutineScope(Dispatchers.Default) {
    
    private var selectedIngredients: List<String> = emptyList()
    private var lastQuerySignature: String? = null
    private var debounceJob: Job? = null

    private fun normalize(list: List<String>): List<String> =
        list.map { it.trim() }
            .filter { it.isNotEmpty() }
            .map { it.lowercase() }
            .distinct()
            .map { s -> s.replaceFirstChar { it.uppercase() } }

    private fun signatureOf(list: List<String>): String =
        list.map { it.trim().lowercase() }
            .filter { it.isNotEmpty() }
            .toSet()
            .sorted()
            .joinToString(",")

    override fun dispatch(action: RecipeAction) {
        val oldState = state.value
        val newState: RecipeState = when (action) {

            is RecipeAction.Data -> {
                if (oldState.progress) {
                    RecipeState(
                        progress = false,
                        searchRecipes = action.searchRecipe,
                        selectedIngredientNames = oldState.selectedIngredientNames
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

            is RecipeAction.Initialize -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(RecipeSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    launch { initFromStored() }
                    oldState.copy(progress = true)
                }
            }

            is RecipeAction.RecommendRecipes -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(RecipeSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    scheduleRecommend(immediate = true)
                    oldState.copy(progress = true)
                }
            }
            
            is RecipeAction.UpdateSelectedIngredients -> {
                val newList = normalize(action.ingredients)
                val changed = newList != selectedIngredients
                selectedIngredients = newList
                if (changed) {
                    scheduleRecommend(immediate = false)
                    oldState.copy(
                        progress = true,
                        selectedIngredientNames = selectedIngredients
                    )
                } else {
                    oldState.copy(
                        selectedIngredientNames = selectedIngredients
                    )
                }
            }
        }

        if (newState != oldState) {
            state.value = newState
        }
    }

    private fun scheduleRecommend(immediate: Boolean) {
        debounceJob?.cancel()
        val targetSignature = signatureOf(selectedIngredients)
        // Skip scheduling if nothing changed and not forced immediate
        if (targetSignature == lastQuerySignature && !immediate) return

        val waitMs = if (immediate) 0L else 400L
        debounceJob = launch {
            if (waitMs > 0) delay(waitMs)
            val currentSignature = signatureOf(selectedIngredients)
            if (currentSignature == lastQuerySignature && !immediate) return@launch
            lastQuerySignature = currentSignature
            recommendIngredient()
        }
    }

    private suspend fun initFromStored() {
        try {
            val stored = retrieveIngredients().map { it.name }
            selectedIngredients = normalize(stored)
            // Reflect in UI state
            state.value = state.value.copy(selectedIngredientNames = selectedIngredients)
            // Trigger initial recommendation immediately
            scheduleRecommend(immediate = true)
        } catch (e: Exception) {
            e.printStackTrace()
            dispatch(RecipeAction.Error(e))
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