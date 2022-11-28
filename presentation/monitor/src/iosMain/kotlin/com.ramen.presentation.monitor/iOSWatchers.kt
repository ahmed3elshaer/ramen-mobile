package com.ramen.presentation.monitor

import com.ramen.presentation.wrap

fun MonitorStore.watchState() = observeState().wrap()
fun MonitorStore.watchSideEffect() = observeSideEffect().wrap()