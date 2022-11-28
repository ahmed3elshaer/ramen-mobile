package com.ramen.presentation

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

interface State
interface Action
interface Effect

abstract class Store<S : State, A : Action, E : Effect>(initialState: S) {
    protected val state = MutableStateFlow(initialState)
    protected val sideEffect = MutableSharedFlow<E>()
    fun observeState(): StateFlow<S> = state
    fun observeSideEffect(): Flow<E> = sideEffect
    abstract fun dispatch(action: A)
}