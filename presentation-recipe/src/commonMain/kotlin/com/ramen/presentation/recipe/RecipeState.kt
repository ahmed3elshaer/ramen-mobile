package com.ramen.presentation.recipe

import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import com.ramen.recipe.domain.model.SearchRecipe

data class RecipeState(
    val progress: Boolean,
    val searchRecipes: List<SearchRecipe>,
    val selectedIngredientNames: List<String>
) : State {
    companion object {
        val Initial = RecipeState(
            progress = false,
            searchRecipes = emptyList(),
            selectedIngredientNames = emptyList()
        )
    }
}


sealed class RecipeAction : Action {
    object Initialize : RecipeAction()
    object RecommendRecipes : RecipeAction()
    data class UpdateSelectedIngredients(val ingredients: List<String>) : RecipeAction()

    data class Data(val searchRecipe: List<SearchRecipe>) : RecipeAction()
    data class Error(val error: Exception) : RecipeAction()
}

sealed class RecipeSideEffect : Effect {
    data class Error(val error: Exception) : RecipeSideEffect()
}