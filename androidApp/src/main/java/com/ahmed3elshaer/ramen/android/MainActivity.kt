package com.ahmed3elshaer.ramen.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.Button
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import com.ramen.presentation.recipe.RecipeAction
import com.ramen.presentation.recipe.RecipeStore
import org.koin.androidx.compose.get
import kotlin.time.ExperimentalTime

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    GreetingView()
                }
            }
        }
    }
}

@OptIn(ExperimentalTime::class)
@Composable
fun GreetingView(store: RecipeStore = get()) {
    val state = store.observeState().collectAsState()

    Column() {
        Button(onClick = {
            store.dispatch(RecipeAction.RecommendRecipes)
        }) {
            Text(text = state.value.progress.toString())
        }
    }

}
