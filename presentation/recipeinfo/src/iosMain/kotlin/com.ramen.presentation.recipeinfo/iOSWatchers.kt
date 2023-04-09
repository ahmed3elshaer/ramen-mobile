package com.ramen.presentation.recipeinfo

import com.ramen.presentation.recipeinfo.RecipeInfoStore
import com.ramen.presentation.wrap

fun RecipeInfoStore.watchState() = observeState().wrap()
fun RecipeInfoStore.watchSideEffect() = observeSideEffect().wrap()