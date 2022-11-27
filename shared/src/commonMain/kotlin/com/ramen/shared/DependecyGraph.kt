package com.ramen.shared

import com.ramen.ingredient.data.di.IngredientsDataDI
import com.ramen.recipe.data.di.RecipeDataDI
import org.koin.dsl.module

val dependencyGraph = module {
    includes(dataGraph)
    includes(domainGraph)
    includes(presentationGraph)
}

internal val dataGraph = module {
    includes(IngredientsDataDI.module)
    includes(RecipeDataDI.module)
}
internal val domainGraph = module { }
internal val presentationGraph = module { }