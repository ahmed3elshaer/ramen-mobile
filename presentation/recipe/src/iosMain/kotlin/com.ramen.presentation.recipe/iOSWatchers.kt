package com.ramen.presentation.recipe

import com.ramen.presentation.wrap

fun RecipeStore.watchState() = observeState().wrap()
fun RecipeStore.watchSideEffect() = observeSideEffect().wrap()