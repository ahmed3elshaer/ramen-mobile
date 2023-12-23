import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier


@Composable
fun ScrollableColumn(
		modifier: Modifier = Modifier,
		verticalArrangement: Arrangement.Vertical = Arrangement.Top,
		horizontalAlignment: Alignment.Horizontal = Alignment.Start,
		content: @Composable ColumnScope.() -> Unit
) {
	Column(modifier = modifier.verticalScroll(rememberScrollState()),
			verticalArrangement = verticalArrangement,
			horizontalAlignment = horizontalAlignment,
			content = content)
}