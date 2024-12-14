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
    @StateObject private var store: StoreIngredientWrapper = StoreIngredientWrapper()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomSearchBar(text: $searchText)
                    .onChange(of: searchText) { query in
                        if !query.isEmpty && query.count > 2 {
                            store.dispatch(StoreAction.RecommendIngredient(name: query))
                        }
                    }
                
                List(store.state.ingredients.map { IdentifiableIngredient(ingredient: $0) }, id: \.id) { ingredient in
                    Button(action: {
                        selectedIngredient = ingredient
                    }) {
                        Text(ingredient.ingredient.name)
                            .typography(.p1)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Add Ingredient")
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

struct StoreIngredientScreen_Previews: PreviewProvider {
	static var previews: some View {
		StoreIngredientsScreen()
	}

}

