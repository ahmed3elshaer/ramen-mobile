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
    @Environment(\.colorScheme) var colorScheme
    @SwiftUI.State private var scannerOffset: CGFloat = UIScreen.main.bounds.height
    @SwiftUI.State private var debouncedSearchText = ""
    
    // MARK: - Debounced Search Timer
    @SwiftUI.State private var searchTimer: Timer?
    
    var body: some View {
        ZStack {
            // MARK: - Dark Background Gradient (Matching Image)
            LinearGradient(
               gradient: Gradient(colors: colorScheme == .dark ? [
                    Color.darkMint.opacity(0.3),
                    Color.forestGreen.opacity(0.2),
                    Color.oceanBlue.opacity(0.1),
                    Color.background
                ] : [
                    Color.pastelBlue.opacity(0.4),
                    Color.laurelGreen.opacity(0.3),
                    Color.lemonMeringue.opacity(0.1),
                    Color.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 0) {
                    // MARK: - Popular Items Section
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            Text("Popular Items")
                                .typography(.h4)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("\(store.state.ingredients.count) items")
                                .typography(.c1)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        
                        // Grid Layout
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 8)
                            ], spacing: 8) {
                                ForEach(store.state.ingredients.map { IdentifiableIngredient(ingredient: $0) }) { ingredient in
                                    PopularItemCard(ingredient: ingredient)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                selectedIngredient = ingredient
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20) // Add bottom padding for better scrolling
                        }
                    }
//                    // MARK: - Top Action Buttons (Matching Image Design)
//                    HStack(spacing: 16) {
//                        // Snap Recipe Button
//                        ActionButton(
//                            icon: "book.fill",
//                            title: "Snap Recipe",
//                            subtitle: "Extract ingredients",
//                            gradientColors: [Color.purple.opacity(0.8), Color.purple.opacity(0.6)],
//                            action: { /* Handle recipe snapping */ }
//                        )
//                        
//                        // Scan Item Button
//                        ActionButton(
//                            icon: "camera.fill",
//                            title: "Scan Item",
//                            subtitle: "Use camera",
//                            gradientColors: [Color.green.opacity(0.8), Color.green.opacity(0.6)],
//                            action: { isScanning = true }
//                        )
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
                    
                }
                .navigationTitle("Add Ingredients")
                .navigationBarTitleDisplayMode(.inline)
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: "Search ingredients..."
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onChange(of: searchText) { query in
                // Debounce search with minimum 3 characters
                searchTimer?.invalidate()
                
                if query.count >= 3 {
                    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        debouncedSearchText = query
                        store.dispatch(StoreAction.RecommendIngredient(name: query))
                    }
                } else if query.isEmpty {
                    debouncedSearchText = ""
                    // Clear results when search is empty
                }
            }
            
            // MARK: - Scanner Overlay
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
        .onAppear {
            // Load popular ingredients if none are loaded
            if store.state.ingredients.isEmpty {
                loadPopularIngredients()
            }
        }
    }
    
    // MARK: - Helper Methods
    private func loadPopularIngredients() {
        // Load popular ingredients to match the image
        let popularIngredients = [
            "Fresh Avocado",
            "Cherry Tomatoes", 
            "Fresh Basil",
            "Cheddar Cheese",
            "Blueberries",
            "Salmon Fillet"
        ]
        
        popularIngredients.forEach { ingredientName in
            store.dispatch(StoreAction.RecommendIngredient(name: ingredientName))
        }
    }
}

// MARK: - Action Button Component
struct ActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .typography(.s1)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .typography(.c1)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Popular Item Card Component
struct PopularItemCard: View {
    let ingredient: IdentifiableIngredient
    
    private var categoryColor: Color {
        // Map categories to colors based on ingredient name
        let name = ingredient.ingredient.name.lowercased()
        if name.contains("avocado") || name.contains("blueberry") {
            return .pink
        } else if name.contains("tomato") {
            return .red
        } else if name.contains("basil") {
            return .green
        } else if name.contains("cheese") {
            return .yellow
        } else if name.contains("salmon") {
            return .orange
        } else {
            return .blue
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Image with responsive height
            GeometryReader { geometry in
                AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(ingredient.ingredient.image)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    // Custom placeholder based on ingredient type
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [categoryColor.opacity(0.3), categoryColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: getPlaceholderIcon())
                                .foregroundColor(categoryColor)
                                .font(.title2)
                        )
                }
                .frame(width: geometry.size.width, height: geometry.size.width * 0.8) // Maintain aspect ratio
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .aspectRatio(1.25, contentMode: .fit) // 5:4 aspect ratio for consistent card heights
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.ingredient.name)
                    .typography(.s1)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(categoryColor)
                        .frame(width: 6, height: 6)
                    
                    Text(getCategoryName())
                        .typography(.c2)
                        .foregroundColor(.white.opacity(0.8))
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .padding(8)
        .frame(minWidth: 140, minHeight: 180) // Ensure minimum size for readability
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
        )
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    private func getCategoryName() -> String {
        let name = ingredient.ingredient.name.lowercased()
        if name.contains("avocado") || name.contains("blueberry") {
            return "FRUIT"
        } else if name.contains("tomato") {
            return "VEGETABLE"
        } else if name.contains("basil") {
            return "HERB"
        } else if name.contains("cheese") {
            return "DAIRY"
        } else if name.contains("salmon") {
            return "PROTEIN"
        } else {
            return "INGREDIENT"
        }
    }
    
    private func getPlaceholderIcon() -> String {
        let name = ingredient.ingredient.name.lowercased()
        if name.contains("avocado") {
            return "leaf.fill"
        } else if name.contains("tomato") {
            return "circle.fill"
        } else if name.contains("basil") {
            return "leaf"
        } else if name.contains("cheese") {
            return "square.fill"
        } else if name.contains("blueberry") {
            return "circle.fill"
        } else if name.contains("salmon") {
            return "fish"
        } else {
            return "photo"
        }
    }
}

struct StoreIngredientScreen_Previews: PreviewProvider {
	static var previews: some View {
		StoreIngredientsScreen()
	}
}

