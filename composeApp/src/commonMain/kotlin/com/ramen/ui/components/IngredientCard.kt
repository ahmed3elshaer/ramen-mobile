package com.ramen.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import coil3.compose.rememberAsyncImagePainter
import com.ramen.ingredients.domain.model.Ingredient

@Composable
fun IngredientCard(
    ingredient: Ingredient,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Ingredient Image
            AsyncImage(
                model = rememberAsyncImagePainter(ingredient.image),
                contentDescription = ingredient.name,
                modifier = Modifier
                    .size(60.dp)
                    .clip(RoundedCornerShape(8.dp)),
                contentScale = ContentScale.Crop
            )
            
            Spacer(modifier = Modifier.width(16.dp))
            
            // Ingredient Info
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = ingredient.name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
                
                Spacer(modifier = Modifier.height(4.dp))
                
                Text(
                    text = "Expires in ${ingredient.durationUntilExpiry()} days",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                
                Spacer(modifier = Modifier.height(8.dp))
                
                // Progress indicator for expiry
                LinearProgressIndicator(
                    progress = { ingredient.expiryProgress().toFloat() },
                    modifier = Modifier.fillMaxWidth(),
                    color = when {
                        ingredient.expiryProgress() > 0.7f -> MaterialTheme.colorScheme.error
                        ingredient.expiryProgress() > 0.4f -> MaterialTheme.colorScheme.tertiary
                        else -> MaterialTheme.colorScheme.primary
                    }
                )
            }
        }
    }
} 