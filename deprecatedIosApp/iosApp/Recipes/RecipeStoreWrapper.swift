//
//  RecipeStoreWrapper.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/28/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

class RecipeStoreWrapper: ObservableObject {
    @Published public var state: RecipeState = RecipeState.companion.Initial
    @Published public var sideEffect: RecipeSideEffect?

    let store = DependencyContainer.KotlinDependencies.shared.getRecipeStore()

    var stateWatcher: Closeable?
    var sideEffectWatcher: Closeable?

    init() {
        stateWatcher = store.watchState().watch { [weak self] state in
            self?.state = state
        }
        sideEffectWatcher = store.watchSideEffect().watch { [weak self] state in
            self?.sideEffect = state
        }
    }

    public func dispatch(_ action: RecipeAction) {
        store.dispatch(action: action)
    }

    deinit {
        stateWatcher?.close()
        sideEffectWatcher?.close()
    }
}
