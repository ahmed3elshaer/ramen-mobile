package com.ramen.shared

import com.ramen.ingredient.data.di.IngredientsDataDI
import com.ramen.ingredients.domain.di.IngredientsDomainDI
import com.ramen.presentation.monitor.di.MonitorStoreDI
import com.ramen.presentation.recipe.di.RecipeStoreDI
import com.ramen.presentation.store.StoreIngredientStore
import com.ramen.presentation.store.di.StoreIngredientDI
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
    includes(MonitorStoreDI.module)
    includes(StoreIngredientDI.module)
    includes(RecipeStoreDI.module)
}

val dependencyGraph = module {
    includes(dataGraph)
    includes(domainGraph)
    includes(presentationGraph)
}