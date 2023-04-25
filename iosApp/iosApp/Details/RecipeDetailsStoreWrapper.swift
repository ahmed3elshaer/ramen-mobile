//
//  MonitorStoreWrapper.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/28/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import shared
import Foundation
import Combine

class RecipeDetailsStoreWrapper : ObservableObject {
    @Published public var state: RecipeInfoState = RecipeInfoState.companion.Initial
    @Published public var sideEffect: RecipeInfoSideEffect?
    
    let store = DependencyContainer.KotlinDependencies.shared.getRecipeInfoStore()
    
    var stateWatcher : Closeable?
    var sideEffectWatcher : Closeable?
    
    
    init() {
            stateWatcher = self.store.watchState().watch { [weak self] state in
                self?.state = state
            }
            sideEffectWatcher = self.store.watchSideEffect().watch { [weak self] state in
                self?.sideEffect = state
            }
        }
     
    public func dispatch(_ action: RecipeInfoAction) {
          store.dispatch(action: action)
      }
    
    deinit {
            stateWatcher?.close()
            sideEffectWatcher?.close()
        }

}



