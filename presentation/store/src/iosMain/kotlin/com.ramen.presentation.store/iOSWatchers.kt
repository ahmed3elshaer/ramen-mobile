package com.ramen.presentation.store

import com.ramen.presentation.wrap

fun StoreIngredientStore.watchState() = observeState().wrap()
fun StoreIngredientStore.watchSideEffect() = observeSideEffect().wrap()