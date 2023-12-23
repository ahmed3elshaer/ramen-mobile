package com.ahmed3elshaer.ramen.android

import ScrollableColumn
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.Button
import androidx.compose.material.Icon
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.ingredients.domain.model.Ingredient
import com.ramen.presentation.monitor.MonitorAction.*
import com.ramen.presentation.monitor.MonitorSideEffect
import com.ramen.presentation.monitor.MonitorStore


@Composable
fun HomeScreen(store: MonitorStore) {
	val state = store.observeState().collectAsState()
	val sideEffect = store.observeSideEffect().collectAsState(MonitorSideEffect.Initial)
	val ingredients: List<Ingredient> = state.value.ingredients

	LaunchedEffect(Unit) {
		store.dispatch(Refresh)
	}

	Column {
		ScrollableColumn(modifier = Modifier.padding(16.dp)) {

			Spacer(Modifier.requiredHeight(40.dp))

			Text(text = sideEffect.toString() ?: "")
			Text(text = "Fridge Storage",
					style = MaterialTheme.typography.h2,
					modifier = Modifier
							.padding()
							.fillMaxWidth()
							.wrapContentWidth(Alignment.Start)
			)

			// Button is a simpler equivalent of ThemeButton in Swift UI
			Button(onClick = { storeIngredient(store) }) {
				Icon(Icons.Filled.AddCircle, contentDescription = null)
				Text("Store Ingredient")
			}

			LazyColumn {
				items(ingredients) { ->
					StoredIngredientCard(
							imageUrl = ingredient.image,
							name = ingredient.name,
							totalDays = ingredient.totalDurationInDays(),
							remainingDays = ingredient.durationUntilExpiry(),
							progress = ingredient.expiryProgress()
					)
				}
			}
		}
	}
}

@Composable
fun StoredIngredientCard(imageUrl: String, name: String, totalDays: String, remainingDays: String, progress: Double) {

}

private fun storeIngredient(store: MonitorStore) {
	// Duration calculations
	val durationPerDay = 24 * 60 * 60 * 1000000000 * 2L
	store.dispatch(StoreIngredient(
			autocompleteIngredient = AutocompleteIngredient(
					id = 9266,
					image = "https://loremflickr.com/640/480",
					name = "Carrot"
			),
			expiryDuration = 10 * durationPerDay
	))
	store.dispatch(MonitorAction.Refresh())
}