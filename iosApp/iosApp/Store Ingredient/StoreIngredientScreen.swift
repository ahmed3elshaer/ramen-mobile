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

struct CustomSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.primary)
            TextField("Search ingredients", text: $text)
                .typography(.p2)
                .foregroundColor(.secondary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            if !text.isEmpty {
                ThemeButton(
                    image: Image(systemName: "xmark.circle.fill"),
                    style: .ghost,
                    action: { text = "" }
                )
            }
        }
        .padding(12)
        .background(Color.basic.opacity(0.1))
        .cornerRadius(45)
        .padding(.horizontal)
    }
}

struct ExpiryPickerView: View {
    let ingredient: Shared.AutocompleteIngredient
    let onSave: (Int64) -> Void
    @Environment(\.dismiss) var dismiss
    
    @SwiftUI.State private var selectedUnit = 0
    @SwiftUI.State private var selectedNumber = 0
    
    let units = ["Days", "Weeks", "Months"]
    let numbers = Array(1...90)
    
    var durationInNanos: Int64 {
        let daysInMonth = 30
                let secondsInDay: Int64 = 24 * 60 * 60
                let nanosInSecond: Int64 = 1_000_000_000
                
                let days: Int
                switch units[selectedUnit] {
                    case "Days": days = numbers[selectedNumber]
                    case "Weeks": days = numbers[selectedNumber] * 7
                    case "Months": days = numbers[selectedNumber] * daysInMonth
                    default: days = numbers[selectedNumber]
                }
                
                return Int64(days) * secondsInDay * nanosInSecond * 2
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("How long will it stay fresh?")
                    .typography(.h2)
                    .padding(.top)
                
                HStack {
                    Picker("Number", selection: $selectedNumber) {
                        ForEach(0..<numbers.count, id: \.self) { index in
                            Text("\(numbers[index])")
                                .typography(.p1)
                                .tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100)
                    
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(0..<units.count, id: \.self) { index in
                            Text(units[index])
                                .typography(.p1)
                                .tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100)
                }
                .padding()
                
                ThemeButton(
                    text: "Add to Fridge",
                    style: .fill,
                    color: .activePrimary,
                    action: {
                        onSave(durationInNanos)
                        dismiss()
                    }
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarItems(trailing:
                ThemeButton(
                    text: "Cancel",
                    style: .ghost,
                    action: { dismiss() }
                )
            )
        }
    }
}

// Quick action button component
struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .typography(.s2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.basic.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// Enhanced ingredient card with animations
struct IngredientCard: View {
    let ingredient: IdentifiableIngredient
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(ingredient.ingredient.image)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
            
            Text(ingredient.ingredient.name)
                .typography(.s1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.basic.opacity(0.05))
        .cornerRadius(16)
        .transition(.scale.combined(with: .opacity))
    }
}

struct StoreIngredientScreen_Previews: PreviewProvider {
	static var previews: some View {
		StoreIngredientsScreen()
	}

}

