package com.ramen.presentation.monitor

import com.ramen.ingredients.domain.usecase.RetrieveIngredients
import com.ramen.ingredients.domain.usecase.StoreIngredient
import com.ramen.presentation.Store
import io.github.aakira.napier.Napier
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class MonitorStore(
    private val retrieveIngredients: RetrieveIngredients,
    private val storeIngredient: StoreIngredient
) : Store<MonitorState, MonitorAction, MonitorSideEffect>(MonitorState.Initial),
    CoroutineScope by CoroutineScope(Dispatchers.Main) {

    override fun dispatch(action: MonitorAction) {
        Napier.d(tag = "MonitorStore", message = "Action: $action")
        val oldState = state.value
        val newState: MonitorState = when (action) {
            is MonitorAction.Error -> {
                if (oldState.progress) {
                    Napier.e { action.error.stackTraceToString() }
                    launch { sideEffect.emit(MonitorSideEffect.Error(action.error)) }
                    oldState.copy(progress = false)
                } else {
                    launch { sideEffect.emit(MonitorSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            is MonitorAction.Data -> {
                if (oldState.progress) {
                    MonitorState(progress = false, ingredients = action.ingredients)
                } else {
                    launch { sideEffect.emit(MonitorSideEffect.Error(Exception("In progress"))) }
                    oldState
                }
            }

            MonitorAction.Refresh -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(MonitorSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    launch { loadAllIngredients() }
                    oldState.copy(progress = true)
                }
            }

            is MonitorAction.StoreIngredient -> {
                if (oldState.progress) {
                    launch { sideEffect.emit(MonitorSideEffect.Error(Exception("In progress"))) }
                    oldState
                } else {
                    launch { storeIngredient(action) }
                    oldState.copy(progress = true)
                }
            }
        }

        if (newState != oldState) {
            Napier.d(tag = "FeedStore", message = "NewState: $newState")
            state.value = newState
        }
    }

    private suspend fun loadAllIngredients() {
        try {
            dispatch(MonitorAction.Data(retrieveIngredients()))
        } catch (e: Exception) {
            e.printStackTrace()
            dispatch(MonitorAction.Error(e))
        }
    }

    private suspend fun storeIngredient(action: MonitorAction.StoreIngredient) {
        try {
            storeIngredient(action.autocompleteIngredient, action.expiryDuration)
            dispatch(MonitorAction.Data(retrieveIngredients()))
        } catch (e: Exception) {
            e.printStackTrace()
            dispatch(MonitorAction.Error(e))

        }
    }
}