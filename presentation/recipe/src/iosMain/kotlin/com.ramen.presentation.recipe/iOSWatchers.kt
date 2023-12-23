package com.ramen.presentation.recipe

import com.ramen.presentation.monitor.MonitorStore
import com.ramen.presentation.recipeinfo.RecipeInfoStore
import com.ramen.presentation.store.StoreIngredientStore
import com.ramen.presentation.wrap

fun RecipeStore.watchState() = observeState().wrap()
fun RecipeStore.watchSideEffect() = observeSideEffect().wrap()

fun RecipeInfoStore.watchState() = observeState().wrap()
fun RecipeInfoStore.watchSideEffect() = observeSideEffect().wrap()

fun MonitorStore.watchState() = observeState().wrap()
fun MonitorStore.watchSideEffect() = observeSideEffect().wrap()

fun StoreIngredientStore.watchState() = observeState().wrap()
fun StoreIngredientStore.watchSideEffect() = observeSideEffect().wrap()