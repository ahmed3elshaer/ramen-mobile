package com.ramen.presentation.recipe

import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import com.ramen.recipe.domain.model.SearchRecipe

data class RecipeState(
    val progress: Boolean,
    val searchRecipes: List<SearchRecipe>
) : State {
    companion object {
        val Initial = RecipeState(
            progress = false,
            searchRecipes = emptyList()
        )
    }
}


sealed class RecipeAction : Action {
    object RecommendRecipes : RecipeAction()

    data class Data(val searchRecipe: List<SearchRecipe>) : RecipeAction()
    data class Error(val error: Exception) : RecipeAction()
}

sealed class RecipeSideEffect : Effect {
    data class Error(val error: Exception) : RecipeSideEffect()
}