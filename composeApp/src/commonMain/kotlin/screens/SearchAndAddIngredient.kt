package screens

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.ramen.presentation.store.StoreAction
import com.ramen.presentation.store.StoreIngredientStore
import com.ramen.presentation.store.StoreSideEffect
import com.ramen.recipe.domain.model.AutocompleteIngredient
import io.kamel.image.KamelImage
import io.kamel.image.asyncPainterResource
import moe.tlaster.precompose.flow.collectAsStateWithLifecycle
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource
import org.koin.compose.koinInject
import ramen.composeapp.generated.resources.Res
import ramen.composeapp.generated.resources.search
import kotlin.time.Duration.Companion.days

@Composable
fun SearchAndAddIngredient(store: StoreIngredientStore = koinInject()) {
    val state = store.observeState().collectAsStateWithLifecycle()
    val effect = store.observeSideEffect().collectAsStateWithLifecycle(StoreSideEffect.Idle)
    SearchScreen(
        onSearch = { store.dispatch(StoreAction.RecommendIngredient(it)) },
        popularSearches = emptyList(),
        searchResults = state.value.ingredients,
        onResultClick = { store.dispatch(StoreAction.StoreIngredient(it, 3.days)) },
        isLoading = state.value.progress,
        error = effect.value.let { (it as? StoreSideEffect.Error)?.error?.message }
    )
}

@Composable
fun SearchScreen(
    onSearch: (String) -> Unit,
    popularSearches: List<String>,
    searchResults: List<AutocompleteIngredient>,
    onResultClick: (AutocompleteIngredient) -> Unit,
    isLoading: Boolean,
    error: String?
) {
    Column(modifier = Modifier.padding(16.dp)) {
        SearchBar(onSearch)
        Spacer(modifier = Modifier.height(16.dp))
        PopularSearch(popularSearches)
        Spacer(modifier = Modifier.height(16.dp))
        SearchResult(searchResults, onResultClick, isLoading, error)
    }
}

@OptIn(ExperimentalResourceApi::class)
@Composable
fun SearchBar(onSearch: (String) -> Unit) {
    val shape = RoundedCornerShape(50)
    val value = remember { mutableStateOf("") }
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .clip(shape)
            .border(BorderStroke(1.dp, MaterialTheme.colors.onBackground), shape)
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        BasicTextField(
            value = value.value,
            onValueChange = {
                value.value = it
                onSearch(value.value)
            },
            textStyle = TextStyle(color = MaterialTheme.colors.onBackground, fontSize = 16.sp),
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
            decorationBox = { innerTextField ->
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(end = 32.dp),
                    contentAlignment = Alignment.CenterStart
                ) {
                    Icon(
                        painter = painterResource(resource = Res.drawable.search),
                        contentDescription = "Search",
                        tint = MaterialTheme.colors.onBackground,
                    )
                    innerTextField()
                }
            }
        )
    }
}

@Composable
fun PopularSearch(popularSearches: List<String>) {
    Text(
        "Popular Search",
        style = MaterialTheme.typography.h6.copy(color = MaterialTheme.colors.primary)
    )
    Spacer(modifier = Modifier.height(8.dp))
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        popularSearches.take(6).forEach { Chip(label = it) }
    }
}

@Composable
fun Chip(label: String) {
    Surface(
        color = MaterialTheme.colors.primary,
        shape = RoundedCornerShape(50),
        contentColor = MaterialTheme.colors.onPrimary
    ) {
        Text(text = label, modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp))
    }
}

@Composable
fun SearchResult(
    searchResults: List<AutocompleteIngredient>,
    onResultClick: (AutocompleteIngredient) -> Unit,
    isLoading: Boolean,
    error: String?
) {
    if (isLoading) {
        CircularProgressIndicator()
    } else {
        LazyColumn {
            item {
                if (error != null) {
                    Text(error, color = Color.Red)
                }
            }
            items(searchResults) { result ->
                SearchResultItem(result, onResultClick)
                Divider()
            }
        }
    }
}

@Composable
fun SearchResultItem(result: AutocompleteIngredient, onClick: (AutocompleteIngredient) -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.clickable { onClick(result) }
    ) {
        KamelImage(
            resource = asyncPainterResource(result.image),
            contentDescription = result.name,
            modifier = Modifier.size(40.dp).clip(CircleShape)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Column {
            Text(result.name, style = MaterialTheme.typography.h6)
        }
    }
}