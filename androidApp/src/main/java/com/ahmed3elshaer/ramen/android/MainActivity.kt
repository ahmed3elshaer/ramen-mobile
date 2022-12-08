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
import com.ramen.presentation.monitor.MonitorAction
import com.ramen.presentation.monitor.MonitorStore
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
fun GreetingView(monitorStore: MonitorStore = get()) {
    val state = monitorStore.observeState().collectAsState()
    Column() {
        Button(onClick = {
            storeIngredient(monitorStore)
        }) {
            Text(text = "Add New One")
        }
        LazyColumn(){
           items(state.value.ingredients){ item->
            Column() {
               Text(text = " ${item.expirationAt}")
               Text(text = "progress  ${item.expiryProgress()}")
               Text(text = "total  ${item.totalDurationInDays()}")
               Text(text = "remaining  ${item.durationUntilExpiry()}")
            }

            }
        }
    }

}

private fun storeIngredient(monitorStore: MonitorStore) {
    monitorStore.dispatch(
        MonitorAction.StoreIngredient(
            autocompleteIngredient = AutocompleteIngredient(
                id = 9266,
                image = "https://loremflickr.com/640/480", name = "Carrot"
            ), expiryDuration = 7.days
        )
    )
}

