package com.ramen.presentation.recipeinfo

import com.ramen.presentation.Action
import com.ramen.presentation.Effect
import com.ramen.presentation.State
import com.ramen.recipe.domain.model.Recipe

data class RecipeInfoState(
    val progress: Boolean,
    val recipe: Recipe
) : State {
    companion object {
        val Initial = RecipeInfoState(
            progress = false,
            recipe = Recipe.Initial
        )
    }
}


sealed class RecipeInfoAction : Action {
    data class GetRecipeInfo(val id: String) : RecipeInfoAction()
    data class Data(val recipe: Recipe) : RecipeInfoAction()
    data class Error(val error: Exception) : RecipeInfoAction()
}

sealed class RecipeInfoSideEffect : Effect {
    data class Error(val error: Exception) : RecipeInfoSideEffect()
}