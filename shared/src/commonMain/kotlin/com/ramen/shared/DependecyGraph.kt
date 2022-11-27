package com.ramen.shared

import com.ramen.ingredient.data.di.IngredientsDataDI
import org.koin.dsl.module

val dependencyGraph = module {
    includes(dataGraph)
    includes(domainGraph)
    includes(presentationGraph)
}

internal val dataGraph = module {
    includes(IngredientsDataDI.module)
}
internal val domainGraph = module { }
internal val presentationGraph = module { }