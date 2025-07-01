package com.ramen.presentation

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

// Marker interfaces for MVI
interface State
interface Action
interface Effect

/**
 * Functional, reactive MVI Store base.
 * - State is immutable and flows down.
 * - Actions are dispatched from the UI.
 * - Side effects are handled and emitted as Effects.
 * - Reducer is a pure function.
 */
interface Store<S : State, A : Action, E : Effect> {
    val state: StateFlow<S>
    val effects: SharedFlow<E>
    fun dispatch(action: A)
}

/**
 * Default implementation of Store using Kotlin Flow and functional principles.
 */
class MviStore<S : State, A : Action, E : Effect>(
    initialState: S,
    private val reducer: (S, A) -> S,
    private val effectHandler: suspend (A, S, suspend (E) -> Unit) -> Unit,
    private val coroutineScope: CoroutineScope
) : Store<S, A, E> {
    private val _state = MutableStateFlow(initialState)
    override val state: StateFlow<S> = _state.asStateFlow()

    private val _effects = MutableSharedFlow<E>()
    override val effects: SharedFlow<E> = _effects.asSharedFlow()

    override fun dispatch(action: A) {
        val prevState = _state.value
        val newState = reducer(prevState, action)
        _state.value = newState
        coroutineScope.launch {
            effectHandler(action, newState) { effect ->
                _effects.emit(effect)
            }
        }
    }
}