package com.ramen.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Restaurant
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.core.screen.Screen
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import com.ramen.ingredients.domain.model.AutocompleteIngredient
import com.ramen.presentation.monitor.MonitorScreenAction
import com.ramen.presentation.monitor.MonitorScreenEffect
import com.ramen.presentation.monitor.MonitorScreenState
import com.ramen.presentation.monitor.MonitorViewModel
import com.ramen.ui.components.IngredientCard
import com.ramen.ui.components.LoadingIndicator
import kotlinx.coroutines.flow.collectLatest
import org.koin.compose.viewmodel.koinViewModel
import kotlin.time.Duration.Companion.days

class MonitorScreen : Screen {
    @Composable
    override fun Content() {
        val navigator = LocalNavigator.currentOrThrow
        val viewModel : MonitorViewModel = koinViewModel()
        val state by viewModel.viewState.collectAsState()
        
        // Handle side effects
        LaunchedEffect(viewModel) {
            viewModel.viewEffects.collectLatest { effect ->
                when (effect) {
                    is MonitorScreenEffect.ShowErrorSnackbar -> {
                        // Handle error snackbar - could be passed to a SnackbarHost
                    }
                }
            }
        }
        
        // Load ingredients when screen appears
        LaunchedEffect(Unit) {
            viewModel.dispatch(MonitorScreenAction.LoadIngredients)
        }
        
        MonitorScreenContent(
            state = state,
            onStoreIngredient = { 
                // Example ingredient - in real app this would come from a form
                val exampleIngredient = AutocompleteIngredient(
                    id = 9266,
                    image = "https://loremflickr.com/640/480",
                    name = "Carrot"
                )
                viewModel.dispatch(
                    MonitorScreenAction.StoreNewIngredient(
                        autocompleteIngredient = exampleIngredient,
                        expiryDuration = 10.days
                    )
                )
            },
            onNavigateToRecipes = {
                navigator.push(RecipeScreen())
            },
            onRefresh = {
                viewModel.dispatch(MonitorScreenAction.LoadIngredients)
            }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun MonitorScreenContent(
    state: MonitorScreenState,
    onStoreIngredient: () -> Unit,
    onNavigateToRecipes: () -> Unit,
    onRefresh: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "Fridge Storage",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold
            )
            
            IconButton(onClick = onNavigateToRecipes) {
                Icon(
                    imageVector = Icons.Default.Restaurant,
                    contentDescription = "View Recipes",
                    tint = MaterialTheme.colorScheme.primary
                )
            }
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Store Ingredient Button
        Button(
            onClick = onStoreIngredient,
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Add,
                contentDescription = null,
                modifier = Modifier.size(18.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text("Store Ingredient")
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Content based on state
        when {
            state.progress -> {
                LoadingIndicator(
                    modifier = Modifier.fillMaxWidth()
                )
            }
            
            state.error != null -> {
                ErrorContent(
                    error = state.error!!,
                    onRetry = onRefresh
                )
            }
            
            state.ingredients.isEmpty() -> {
                EmptyStateContent(
                    onStoreIngredient = onStoreIngredient
                )
            }
            
            else -> {
                IngredientsContent(
                    ingredients = state.ingredients,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }
    }
}

@Composable
private fun IngredientsContent(
    ingredients: List<com.ramen.ingredients.domain.model.Ingredient>,
    modifier: Modifier = Modifier
) {
    LazyColumn(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        items(ingredients) { ingredient ->
            IngredientCard(
                ingredient = ingredient,
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Composable
private fun EmptyStateContent(
    onStoreIngredient: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "No ingredients stored yet",
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(16.dp))
        OutlinedButton(onClick = onStoreIngredient) {
            Text("Add your first ingredient")
        }
    }
}

@Composable
private fun ErrorContent(
    error: String,
    onRetry: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Error: $error",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.error
        )
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onRetry) {
            Text("Retry")
        }
    }
} 