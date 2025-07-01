package com.ramen.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.core.screen.Screen
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import coil3.compose.AsyncImage
import coil3.compose.rememberAsyncImagePainter
import com.ramen.presentation.recipeinfo.RecipeInfoScreenAction
import com.ramen.presentation.recipeinfo.RecipeInfoScreenEffect
import com.ramen.presentation.recipeinfo.RecipeInfoScreenState
import com.ramen.presentation.recipeinfo.RecipeInfoViewModel
import com.ramen.ui.components.LoadingIndicator
import kotlinx.coroutines.flow.collectLatest
import org.koin.compose.viewmodel.koinViewModel

data class RecipeDetailScreen(
    private val recipeId: String
) : Screen {
    @Composable
    override fun Content() {
        val navigator = LocalNavigator.currentOrThrow
        val viewModel :RecipeInfoViewModel= koinViewModel()
        val state by viewModel.viewState.collectAsState()
        
        // Handle side effects
        LaunchedEffect(viewModel) {
            viewModel.viewEffects.collectLatest { effect ->
                when (effect) {
                    is RecipeInfoScreenEffect.ShowErrorSnackbar -> {
                        // Handle error snackbar
                    }
                }
            }
        }
        
        // Load recipe details when screen appears
        LaunchedEffect(recipeId) {
            viewModel.dispatch(RecipeInfoScreenAction.LoadRecipeDetails(recipeId))
        }
        
        RecipeDetailContent(
            state = state,
            onBackClick = { navigator.pop() },
            onRetry = {
                viewModel.dispatch(RecipeInfoScreenAction.LoadRecipeDetails(recipeId))
            }
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun RecipeDetailContent(
    state: RecipeInfoScreenState,
    onBackClick: () -> Unit,
    onRetry: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize()
    ) {
        // Top App Bar
        TopAppBar(
            title = {
                Text(
                    text = state.recipe?.title ?: "Recipe Details",
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
                    error = state.error ?: "Something went wrong",
                    onRetry = onRetry,
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                )
            }
            
            state.recipe != null -> {
                RecipeDetailsContent(
                    recipe = state.recipe!!,
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
    }
}

@Composable
private fun RecipeDetailsContent(
    recipe: com.ramen.recipe.domain.model.Recipe,
    modifier: Modifier = Modifier
) {
    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Recipe Image
        item {
        val imageState = rememberAsyncImagePainter(recipe.image)
            if (recipe.image.isNotEmpty()) {
                AsyncImage(
                    model = imageState,
                    contentDescription = recipe.title,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp)
                        .clip(RoundedCornerShape(12.dp)),
                    contentScale = ContentScale.Crop
                )
            }
        }
        
        // Recipe Info
        item {
            RecipeInfoSection(recipe = recipe)
        }
        
        // Ingredients
        if (recipe.extendedIngredients.isNotEmpty()) {
            item {
                Text(
                    text = "Ingredients",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold
                )
            }
            
            items(recipe.extendedIngredients) { ingredient ->
                IngredientItem(ingredient = ingredient)
            }
        }
        
        // Instructions
        if (recipe.analyzedInstructions.isNotEmpty()) {
            item {
                Text(
                    text = "Instructions",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold
                )
            }
            
            recipe.analyzedInstructions.forEach { instruction ->
                items(instruction.steps) { step ->
                    InstructionStep(step = step)
                }
            }
        }
        
        // Summary
        if (recipe.summary.isNotEmpty()) {
            item {
                Text(
                    text = "Summary",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold
                )
            }
            
            item {
                Card(
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = recipe.summary,
                        style = MaterialTheme.typography.bodyMedium,
                        modifier = Modifier.padding(16.dp)
                    )
                }
            }
        }
    }
}

@Composable
private fun RecipeInfoSection(
    recipe: com.ramen.recipe.domain.model.Recipe
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                InfoChip(
                    label = "Ready in",
                    value = "${recipe.readyInMinutes} min"
                )
                InfoChip(
                    label = "Servings",
                    value = recipe.servings.toString()
                )
                InfoChip(
                    label = "Health Score",
                    value = recipe.healthScore.toString()
                )
            }
            
            if (recipe.diets.isNotEmpty()) {
                Text(
                    text = "Diets: ${recipe.diets.joinToString(", ")}",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

@Composable
private fun InfoChip(
    label: String,
    value: String
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = value,
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Bold
        )
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun IngredientItem(
    ingredient: com.ramen.recipe.domain.model.Recipe.ExtendedIngredient
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = ingredient.original,
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.weight(1f)
            )
        }
    }
}

@Composable
private fun InstructionStep(
    step: com.ramen.recipe.domain.model.Recipe.AnalyzedInstruction.Step
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
        ) {
            Text(
                text = "${step.number}.",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(end = 12.dp)
            )
            Text(
                text = step.step,
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.weight(1f)
            )
        }
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
            text = "Error loading recipe",
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