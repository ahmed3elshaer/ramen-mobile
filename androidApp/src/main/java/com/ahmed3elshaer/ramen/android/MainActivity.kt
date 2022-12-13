package com.ahmed3elshaer.ramen.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.presentation.Store
import com.ramen.presentation.monitor.MonitorAction
import com.ramen.presentation.monitor.MonitorStore
import com.ramen.presentation.recipe.RecipeAction
import com.ramen.presentation.recipe.RecipeStore
import com.ramen.presentation.store.StoreAction
import com.ramen.presentation.store.StoreIngredientStore
import org.koin.androidx.compose.get
import kotlin.time.Duration
import kotlin.time.Duration.Companion.days
import kotlin.time.Duration.Companion.milliseconds
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
