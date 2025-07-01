package com.ramen.ui

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import cafe.adriel.voyager.navigator.Navigator
import com.ramen.shared.dependencyGraph
import com.ramen.ui.screens.MonitorScreen
import com.ramen.ui.theme.RamenTheme
import org.koin.compose.KoinApplication

@Composable
fun App() {
    KoinApplication(application = {
        modules(dependencyGraph)
    }) {
        RamenTheme {
            Surface(
                modifier = Modifier.fillMaxSize(),
                color = MaterialTheme.colorScheme.background
            ) {
                Navigator(MonitorScreen())
            }
        }
    }
}