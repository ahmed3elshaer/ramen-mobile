//
//  StoreIngredientWrapper.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/10/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Combine
import Foundation
import Shared

class StoreIngredientWrapper: ObservableObject {
    @Published public var state: StoreState = StoreState.companion.Initial
    @Published public var sideEffect: StoreSideEffect?

    let store = DependencyContainer.KotlinDependencies.shared.getStoreIngredient()

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

    public func dispatch(_ action: StoreAction) {
        store.dispatch(action: action)
    }

    deinit {
        stateWatcher?.close()
        sideEffectWatcher?.close()
    }
}
