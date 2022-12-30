import androidx.compose.foundation.layout.size
import androidx.compose.material.BottomNavigation
import androidx.compose.material.BottomNavigationItem
import androidx.compose.material.Icon
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.map
import moe.tlaster.precompose.PreComposeApp
import moe.tlaster.precompose.navigation.NavHost
import moe.tlaster.precompose.navigation.rememberNavigator
import navigation.BottomNavItem
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.ui.tooling.preview.Preview
import screens.FavoriteScreen
import screens.FridgeScreen
import screens.RecipesScreen
import screens.SearchAndAddIngredient


@OptIn(ExperimentalResourceApi::class)
@Composable
@Preview
fun App() {
    PreComposeApp {
        val navigator = rememberNavigator()
        MaterialTheme {
            val currentScreen = navigator.currentEntry
                .filterNotNull()
                .map { entry ->
                    BottomNavItem.entries.find { it.route == entry.route.route }
                        ?: BottomNavItem.Nest
                }
                .collectAsState(BottomNavItem.Nest)

            Scaffold(
                bottomBar = {
                    BottomNavigation {
                        BottomNavItem.entries.forEach { screen ->
                            BottomNavigationItem(
                                icon = {
                                    Icon(
                                        modifier = Modifier.size(24.dp),
                                        painter = painterResource(resource = screen.icon),
                                        contentDescription = screen.title
                                    )
                                },
                                label = { Text(screen.title) },
                                selected = currentScreen.value == screen,
                                onClick = {
                                    navigator.navigate(screen.route)
                                }
                            )
                        }
                    }
                }
            ) {
                NavHost(
                    navigator = navigator,
                    initialRoute = BottomNavItem.Nest.route
                ) {
                    scene(BottomNavItem.Nest.route) {
                        FridgeScreen()
                    }
                    scene(BottomNavItem.Store.route) {
                        SearchAndAddIngredient()
                    }
                    scene(BottomNavItem.Recipes.route) {
                        RecipesScreen()
                    }
                    scene(BottomNavItem.Plan.route) {
                        FavoriteScreen()
                    }

                }
            }
        }
    }
}