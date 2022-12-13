package com.ramen.presentation.recipe

import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import com.ramen.recipe.domain.model.Recipe

data class RecipeState(
    val progress: Boolean,
    val recipes: List<Recipe>
) : State {
    companion object {
        val Initial = RecipeState(
            progress = false,
            recipes = emptyList()
        )
    }
}


sealed class RecipeAction : Action {
    object RecommendRecipes : RecipeAction()

    data class Data(val recipe: List<Recipe>) : RecipeAction()
    data class Error(val error: Exception) : RecipeAction()
}

sealed class RecipeSideEffect : Effect {
    data class Error(val error: Exception) : RecipeSideEffect()
}