package design

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import io.kamel.image.KamelImage
import io.kamel.image.asyncPainterResource

@Composable
fun StoredIngredient(
    ingredientImage: String,
    ingredientName: String,
    remainingDays: String,
    totalPeriodDays: String,
    expiryProgress: Double
) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Box {
            KamelImage(
                resource = asyncPainterResource(ingredientImage),
                contentDescription = ingredientName,
                modifier = Modifier.size(100.dp).clip(CircleShape)
            )
            CircularProgressIndicator(
                progress = expiryProgress.toFloat(),
                modifier = Modifier.size(100.dp)
            )
        }
        Text(text = ingredientName, style = MaterialTheme.typography.subtitle1)
        Spacer(modifier = Modifier.size(4.dp))
        Text(
            text = "$remainingDays of $totalPeriodDays days",
            style = MaterialTheme.typography.subtitle2.copy(fontWeight = FontWeight.Bold)
        )
    }
}