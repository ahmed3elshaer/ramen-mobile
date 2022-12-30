package navigation

import org.jetbrains.compose.resources.DrawableResource
import org.jetbrains.compose.resources.ExperimentalResourceApi
import ramen.composeapp.generated.resources.Res
import ramen.composeapp.generated.resources.add
import ramen.composeapp.generated.resources.favorite
import ramen.composeapp.generated.resources.fridge
import ramen.composeapp.generated.resources.recipe

@OptIn(ExperimentalResourceApi::class)
enum class BottomNavItem(val route: String, val icon: DrawableResource, val title: String) {
    Nest("nest", Res.drawable.fridge,"Nest"),
    Store("store", Res.drawable.add, "Store"),
    Recipes("recipes", Res.drawable.recipe, "Recipes"),
    Plan("plan", Res.drawable.favorite, "Plan")
}