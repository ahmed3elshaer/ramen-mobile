package com.ramen.presentation.recipeinfo

import com.ramen.presentation.Store
import com.ramen.recipe.domain.usecase.GetRecipeInfo
import io.github.aakira.napier.Napier
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class RecipeInfoStore(
    private val getRecipeInfo: GetRecipeInfo
) : Store<RecipeInfoState, RecipeInfoAction, RecipeInfoSideEffect>(RecipeInfoState.Initial),
    CoroutineScope by CoroutineScope(Dispatchers.Main) {

    override fun dispatch(action: RecipeInfoAction) {
        val oldState = state.value
        val newState: RecipeInfoState = when (action) {

            is RecipeInfoAction.Data -> {
                if (oldState.progress) {
                    RecipeInfoState(
                        progress = false,
                        recipe = action.recipe
                    )
                } else {
                    launch { sideEffect.emit(RecipeInfoSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            is RecipeInfoAction.Error -> {
                if (oldState.progress) {
                    Napier.e { action.error.stackTraceToString() }
                    launch { sideEffect.emit(RecipeInfoSideEffect.Error(action.error)) }
                    oldState.copy(progress = false)
                } else {
                    launch { sideEffect.emit(RecipeInfoSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            is RecipeInfoAction.GetRecipeInfo -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(RecipeInfoSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    launch { getRecipeInfo(action.id) }
                    oldState.copy(progress = true)
                }
            }
        }

        if (newState != oldState) {
            state.value = newState
        }
    }

    private suspend fun getRecipeInfo(id: String) {
        try {
            dispatch(RecipeInfoAction.Data(getRecipeInfo.invoke(id)))
        } catch (e: Exception) {
            e.printStackTrace()
            dispatch(RecipeInfoAction.Error(e))
        }
    }
}