package com.ramen.shared


import com.ramen.recipe.domain.di.IngredientsDomainDI
import com.ramen.presentation.monitor.MonitorViewModelDI
import com.ramen.presentation.recipe.RecipeViewModelDI
import com.ramen.presentation.recipeinfo.RecipeInfoViewModelDI
import com.ramen.presentation.store.StoreIngredientViewModelDI
import com.ramen.recipe.data.di.IngredientsDataDI
import com.ramen.recipe.data.di.RecipeDataDI
import com.ramen.recipe.domain.di.RecipeDomainDI
import org.koin.dsl.module

internal val dataGraph = module {
	includes(IngredientsDataDI.module)
	includes(RecipeDataDI.module)
}
internal val domainGraph = module {
	includes(IngredientsDomainDI.module)
	includes(RecipeDomainDI.module)
}
internal val presentationGraph = module {
	includes(MonitorViewModelDI.module)
	includes(StoreIngredientViewModelDI.module)
	includes(RecipeViewModelDI.module)
	includes(RecipeInfoViewModelDI.module)
}

val dependencyGraph = module {
	includes(dataGraph)
	includes(domainGraph)
	includes(presentationGraph)
}