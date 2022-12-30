package screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.unit.dp
import com.ramen.ingredients.domain.model.Ingredient
import com.ramen.presentation.monitor.MonitorAction
import com.ramen.presentation.monitor.MonitorStore
import com.ramen.presentation.store.StoreIngredientStore
import design.StoredIngredient
import moe.tlaster.precompose.flow.collectAsStateWithLifecycle
import moe.tlaster.precompose.koin.koinViewModel
import org.koin.compose.koinInject

@Composable
fun FridgeScreen(store: MonitorStore = koinViewModel(MonitorStore::class)) {
    val state = store.observeState().collectAsStateWithLifecycle()

    LaunchedEffect(store) {
        store.dispatch(MonitorAction.Refresh)
    }

    FridgeContent(state.value.ingredients)


}

@Composable
fun FridgeContent(ingredients: List<Ingredient>) {
    Column(modifier = Modifier.fillMaxSize()) {
        Row(modifier = Modifier.align(Alignment.Start)) {
            Text(
                text = "What's in your",
                style = MaterialTheme.typography.h4,

                )
            Text(
                text = " Fridge",
                style = MaterialTheme.typography.h4.copy(
                    brush = Brush.verticalGradient(
                        colors = listOf(
                            MaterialTheme.colors.primary,
                            MaterialTheme.colors.secondary
                        )
                    )
                )
            )
        }

        Spacer(modifier = Modifier.height(16.dp))
        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
        ) {
            items(ingredients) { ingredient ->
                StoredIngredient(
                    ingredientImage = ingredient.image,
                    ingredientName = ingredient.name,
                    remainingDays = ingredient.durationUntilExpiry(),
                    totalPeriodDays = ingredient.totalDurationInDays(),
                    expiryProgress = ingredient.expiryProgress()
                )
            }
        }
    }
}