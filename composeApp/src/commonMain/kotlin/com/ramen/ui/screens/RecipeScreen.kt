package com.ramen.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.core.screen.Screen
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import com.ramen.presentation.recipe.RecipeScreenAction
import com.ramen.presentation.recipe.RecipeScreenEffect
import com.ramen.presentation.recipe.RecipeScreenState
import com.ramen.presentation.recipe.RecipeViewModel
import com.ramen.ui.components.LoadingIndicator
import kotlinx.coroutines.flow.collectLatest
import org.koin.compose.viewmodel.koinViewModel

class RecipeScreen : Screen {
    @Composable
    override fun Content() {
        val navigator = LocalNavigator.currentOrThrow
        val viewModel : RecipeViewModel = koinViewModel<RecipeViewModel>()
        val state by viewModel.viewState.collectAsState()
        
        // Handle side effects
        LaunchedEffect(viewModel) {
            viewModel.viewEffects.collectLatest { effect ->
                when (effect) {
                    is RecipeScreenEffect.ShowErrorSnackbar -> {
                        // Handle error snackbar
                    }
                }
            }
        }
        
        // Load recipes when screen appears
        LaunchedEffect(Unit) {
            viewModel.dispatch(RecipeScreenAction.LoadInitialRecipes)
        }
        
        RecipeScreenContent(
            state = state,
            onBackClick = { navigator.pop() },
            onRecipeClick = { recipeId ->
                navigator.push(RecipeDetailScreen(recipeId))
            },
            onRefresh = {
                viewModel.dispatch(RecipeScreenAction.LoadInitialRecipes)
            }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun RecipeScreenContent(
    state: RecipeScreenState,
    onBackClick: () -> Unit,
    onRecipeClick: (String) -> Unit,
    onRefresh: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = {
                Text(
                    text = "Recipes",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold
                )
            },
            navigationIcon = {
                IconButton(onClick = onBackClick) {
                    Icon(
                        imageVector = Icons.Default.ArrowBack,
                        contentDescription = "Back"
                    )
                }
            }
        )
        
        // Content
        when {
            state.progress -> {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    LoadingIndicator()
                }
            }
            
            state.error != null -> {
                ErrorContent(
                    error = state.error!!,
                    onRetry = onRefresh,
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                )
            }
            
            state.searchRecipes.isEmpty() -> {
                EmptyRecipesContent(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                )
            }
            
            else -> {
                RecipesContent(
                    recipes = state.searchRecipes.sortedByDescending { it.likes },
                    onRecipeClick = onRecipeClick,
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 16.dp)
                )
            }
        }
    }
}

@Composable
private fun RecipesContent(
    recipes: List<com.ramen.recipe.domain.model.SearchRecipe>,
    onRecipeClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    LazyColumn(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        items(recipes) { recipe ->
            RecipeCard(
                recipe = recipe,
                onClick = { onRecipeClick(recipe.id.toString()) },
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Composable
fun RecipeCard(
    recipe: com.ramen.recipe.domain.model.SearchRecipe,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        onClick = onClick,
        modifier = modifier
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = recipe.title,
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = recipe.likes.toString(),
                style = MaterialTheme.typography.bodyMedium,
                maxLines = 3
            )
        }
    }
}
@Composable
private fun EmptyRecipesContent(
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "No recipes found",
            style = MaterialTheme.typography.headlineSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "Add some ingredients to your fridge to get recipe recommendations",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun ErrorContent(
    error: String,
    onRetry: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Error loading recipes",
            style = MaterialTheme.typography.headlineSmall,
            color = MaterialTheme.colorScheme.error
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = error,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onRetry) {
            Text("Retry")
        }
    }
} 