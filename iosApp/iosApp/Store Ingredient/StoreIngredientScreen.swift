//
//  StoreIngredientScreen.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/10/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct StoreIngredientsScreen: View {
    @SwiftUI.State private var searchText = ""
    @SwiftUI.State private var selectedIngredient: IdentifiableIngredient?
    @SwiftUI.State private var isScanning = false
    @StateObject private var store: StoreIngredientWrapper = StoreIngredientWrapper()
    
    @SwiftUI.State private var scannerOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    // Add quick action buttons
                    HStack(spacing: 16) {
                        QuickActionButton(
                            icon: "camera.fill",
                            title: "Scan Items",
                            action: { isScanning = true }
                        )
                        
                        QuickActionButton(
                            icon: "text.viewfinder",
                            title: "Scan Receipt",
                            action: { /* Handle receipt scanning */ }
                        )
                    }
                    .padding()
                    
                    // Existing search bar and list...
                    CustomSearchBar(text: $searchText)
                        .onChange(of: searchText) { query in
                            if !query.isEmpty && query.count > 2 {
                                store.dispatch(StoreAction.RecommendIngredient(name: query))
                            }
                        }
                    
                    // Enhanced ingredient list with animations
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(store.state.ingredients.map { IdentifiableIngredient(ingredient: $0) }) { ingredient in
                                IngredientCard(ingredient: ingredient)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedIngredient = ingredient
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Add Ingredients")
            }
            
            // Scanner overlay
            if isScanning {
                ScannerView(onScanComplete: { ingredients in
                    withAnimation(.spring()) {
                        isScanning = false
                        // Process scanned ingredients
                        ingredients.forEach { ingredient in
                            store.dispatch(StoreAction.RecommendIngredient(name: ingredient.name))
                        }
                    }
                })
                .offset(y: scannerOffset)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .onChange(of: isScanning) { newValue in
            withAnimation(.spring(
                response: 0.6,
                dampingFraction: 0.8,
                blendDuration: 0
            )) {
                scannerOffset = newValue ? 0 : UIScreen.main.bounds.height
            }
        }
        .sheet(item: $selectedIngredient) { ingredient in
            ExpiryPickerView(ingredient: ingredient.ingredient) { duration in
                store.dispatch(StoreAction.StoreIngredient(
                    autocompleteIngredient: ingredient.ingredient,
                    expiryDuration: duration
                ))
            }
            .presentationDetents([.medium])
        }
    }
}

struct StoreIngredientScreen_Previews: PreviewProvider {
	static var previews: some View {
		StoreIngredientsScreen()
	}

}

