//
//  StoreIngredientWrapper.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/10/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import Foundation
import Combine
import Shared

class StoreIngredientWrapper : ObservableObject {
    @Published public var state: StoreState = StoreState.companion.Initial
    @Published public var sideEffect: StoreSideEffect?
    
    let store = DependencyContainer.KotlinDependencies.shared.getStoreIngredient()
    
    var stateWatcher : Closeable?
    var sideEffectWatcher : Closeable?
    
    @Published var smartSuggestions: [IdentifiableIngredient] = []
    
    init() {
        stateWatcher = self.store.watchState().watch { [weak self] state in
            self?.state = state
        }
        sideEffectWatcher = self.store.watchSideEffect().watch { [weak self] state in
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
    
    func generateSmartSuggestions() {
        // Based on user's previous ingredients and seasonal data
        // Implementation for AI-powered suggestions
    }
    
    func addCommonIngredients() {
        // Quick-add common ingredients based on cuisine preferences
    }
}

struct IdentifiableIngredient: Identifiable, Hashable {
    let id = UUID()
    let ingredient: Shared.AutocompleteIngredient
}
