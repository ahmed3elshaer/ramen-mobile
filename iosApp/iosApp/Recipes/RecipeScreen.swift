import SwiftUI
import Shared

struct RecipeScreen: View {
    @SwiftUI.State private var selection: String? = nil
    @StateObject var store: RecipeStoreWrapper = RecipeStoreWrapper()
    @Environment(\.colorScheme) var colorScheme
    @SwiftUI.State private var selectedIngredients: [String] = []
    @SwiftUI.State private var isIngredientSheetPresented = false
    @SwiftUI.State private var selectedIngredientsSheet: [SearchRecipe.Ingredient] = []
    
    var body: some View {
        let recipes = store.state.searchRecipes.sorted { first, second in
            first.likes > second.likes
        }

        NavigationView {
            ZStack {
                // MARK: - Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: colorScheme == .dark ? [
                        Color.black.opacity(0.8),
                        Color.darkMint.opacity(0.4),
                        Color.forestGreen.opacity(0.3),
                        Color.black.opacity(0.9)
                    ] : [
                        Color.black.opacity(0.6),
                        Color.darkMint.opacity(0.3),
                        Color.forestGreen.opacity(0.2),
                        Color.black.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 20) {
                            // MARK: - Ingredients Toolbar
                            IngredientsToolbar(
                                selectedIngredients: $selectedIngredients,
                                onAddIngredient: {
                                    isIngredientSheetPresented = true
                                }
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // MARK: - Header
                            HStack {
                                Text("Recipes")
                                    .typography(.h2)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            // MARK: - Recipe Cards
                            LazyVStack(spacing: 20) {
                                ForEach(recipes, id: \.id.description) { recipe in
                                    NavigationLink(
                                        destination: RecipeDetail(recipeId: recipe.id.description),
                                        tag: recipe.id.description,
                                        selection: $selection
                                    ) {
                                        ModernRecipeCard(recipe: recipe)
                                            .onTapGesture {
                                                // Haptic feedback
                                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                                impactFeedback.impactOccurred()
                                                selection = recipe.id.description
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
        }
        .background(Color.background)
        .sheet(isPresented: $isIngredientSheetPresented) {
            StoreIngredientSelectionSheet(
                selectedIngredients: $selectedIngredientsSheet,
                onIngredientsSelected: { ingredients in
                    // Convert selected items from sheet to names and dispatch
                    let ingredientNames = ingredients.map { $0.name }
                    selectedIngredients = ingredientNames
                    store.dispatch(RecipeAction.UpdateSelectedIngredients(ingredients: ingredientNames))
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            // Initialize from stored ingredients; store will trigger recommendation
            store.dispatch(RecipeAction.Initialize())
        }
        .onReceive(store.$state) { newState in
            // Keep UI in sync with store-selected ingredients
            let names = (newState.selectedIngredientNames as? [String])
                ?? newState.selectedIngredientNames.map { "\($0)" }
            if names != selectedIngredients {
                selectedIngredients = names
            }
        }
        .onChange(of: selectedIngredients) { newValue in
            // Propagate UI changes (e.g., removals) to store; store will debounce/dedupe
            store.dispatch(RecipeAction.UpdateSelectedIngredients(ingredients: newValue))
        }
    }
}

// MARK: - Modern Recipe Card Component
struct ModernRecipeCard: View {
    let recipe: SearchRecipe
    
    private var matchPercentage: Int {
        let totalIngredients = recipe.usedIngredients.count + recipe.missedIngredients.count
        guard totalIngredients > 0 else { return 0 }
        return Int((Double(recipe.usedIngredients.count) / Double(totalIngredients)) * 100)
    }
    
    private var difficulty: String {
        recipe.missedIngredients.count <= 2 ? "Easy" : "Medium"
    }
    
    private var cuisine: String {
        if recipe.title.lowercased().contains("mediterranean") {
            return "Mediterranean"
        } else if recipe.title.lowercased().contains("italian") || recipe.title.lowercased().contains("pasta") {
            return "Italian"
        } else {
            return "International"
        }
    }
    
    private var isVegetarian: Bool {
        recipe.title.lowercased().contains("vegetarian") || 
        recipe.title.lowercased().contains("salad") ||
        recipe.title.lowercased().contains("quinoa")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Image with Overlays
            ZStack {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.title)
                        )
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // MARK: - Top Overlays
                VStack {
                    HStack {
                        // Rating
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text("\(recipe.likes)")
                                .typography(.c2)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .glassEffect()
                        
                        Spacer()
                        
                        // Match Percentage
                        Text("\(matchPercentage)% Match")
                            .typography(.c2)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.mint.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    // MARK: - Bottom Overlays
                    HStack(spacing: 8) {
                        // Used ingredients
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle")
                                .font(.caption)
                                .foregroundColor(.white)
                            Text("\(recipe.usedIngredients.count) used")
                                .typography(.c2)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // Missing ingredients
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.caption)
                                .foregroundColor(.white)
                            Text("\(recipe.missedIngredients.count) missing")
                                .typography(.c2)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .glassEffect()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            }
            
            // MARK: - Content Section
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(recipe.title)
                    .typography(.h4)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                // Tags
                HStack(spacing: 8) {
                    TagView(text: difficulty, icon: "chef.hat", color: .mint)
                    TagView(text: cuisine, icon: "globe", color: .indigo)
                    if isVegetarian {
                        TagView(text: "Vegetarian", icon: "leaf", color: .mint)
                    }
                }
                
                // Ingredient Match
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(recipe.usedIngredients.count) ingredients you have")
                        .typography(.p2)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.mint, Color.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width * CGFloat(matchPercentage) / 100,
                                    height: 8
                                )
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text("\(recipe.usedIngredients.count) have")
                            .typography(.c1)
                            .foregroundColor(.mint)
                        
                        Spacer()
                        
                        Text("\(recipe.missedIngredients.count) missing")
                            .typography(.c1)
                            .foregroundColor(.orange)
                    }
                }
                
                // Info
                HStack(spacing: 20) {
                    NutritionInfo(label: "Likes", value: "\(recipe.likes)")
                    NutritionInfo(label: "Difficulty", value: difficulty)
                    NutritionInfo(label: "Match", value: "\(matchPercentage)%")
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        // Save recipe action
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "bookmark")
                                .font(.caption)
                            Text("Save")
                                .typography(.c2)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassEffect()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Share recipe action
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.caption)
                            Text("Share")
                                .typography(.c2)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .glassEffect()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
        )
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Supporting Components
struct TagView: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text(text)
                .typography(.c2)
                .foregroundColor(color)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct NutritionInfo: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .typography(.c1)
                .foregroundColor(.white.opacity(0.7))
            Text(value)
                .typography(.s1)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
    }
}



// MARK: - Simple Ingredients Toolbar
struct IngredientsToolbar: View {
    @Binding var selectedIngredients: [String]
    let onAddIngredient: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with Add Button
            HStack {
                Text("Ingredients")
                    .typography(.h5)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onAddIngredient) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.caption)
                        Text("Add")
                            .typography(.c2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.mint.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            // Selected Ingredients Tags
            if !selectedIngredients.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedIngredients, id: \.self) { ingredient in
                            IngredientTag(
                                ingredient: ingredient,
                                onRemove: {
                                    selectedIngredients.removeAll { $0 == ingredient }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.5))
        )
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Ingredient Tag Component
struct IngredientTag: View {
    let ingredient: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(ingredient)
                .typography(.c2)
                .foregroundColor(.white)
                .fontWeight(.medium)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


// MARK: - Store Ingredient Selection Sheet
struct StoreIngredientSelectionSheet: View {
    @Binding var selectedIngredients: [SearchRecipe.Ingredient]
    let onIngredientsSelected: ([SearchRecipe.Ingredient]) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Select Ingredients")
                        .typography(.h4)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button("Done") {
                        onIngredientsSelected(selectedIngredients)
                        dismiss()
                    }
                    .typography(.s1)
                    .foregroundColor(.mint)
                    .fontWeight(.medium)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Selected Ingredients Summary
                if !selectedIngredients.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected (\(selectedIngredients.count))")
                            .typography(.c1)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(selectedIngredients, id: \.id) { ingredient in
                                    IngredientTag(
                                        ingredient: ingredient.name,
                                        onRemove: {
                                            selectedIngredients.removeAll { $0.id == ingredient.id }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 40)
                    }
                    .padding(.vertical, 12)
                }
                
                // Store Ingredient Screen (Modified for selection only)
                StoreIngredientSelectionView(
                    selectedIngredients: $selectedIngredients
                )
            }
            .background(Color.background)
        }
    }
}

// MARK: - Modified Store Ingredient View for Selection
struct StoreIngredientSelectionView: View {
    @Binding var selectedIngredients: [SearchRecipe.Ingredient]
    @StateObject private var store: StoreIngredientWrapper = StoreIngredientWrapper()
    @SwiftUI.State private var searchText = ""
    @SwiftUI.State private var searchTimer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                TextField("Search ingredients", text: $searchText)
                    .typography(.p2)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // Ingredients Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 8)
                ], spacing: 8) {
                    ForEach(store.state.ingredients.map { IdentifiableIngredient(ingredient: $0) }) { ingredient in
                        SelectionIngredientCard(
                            ingredient: ingredient,
                            isSelected: selectedIngredients.contains { $0.id == ingredient.ingredient.id },
                            onToggle: {
                                if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.ingredient.id }) {
                                    selectedIngredients.remove(at: index)
                                } else {
                                    // Convert AutocompleteIngredient to SearchRecipe.Ingredient
                                    let searchIngredient = SearchRecipe.Ingredient(
                                        aisle: "General",
                                        amount: 1.0,
                                        id: ingredient.ingredient.id,
                                        image: ingredient.ingredient.image,
                                        name: ingredient.ingredient.name,
                                        original: ingredient.ingredient.name,
                                        originalName: ingredient.ingredient.name,
                                        unit: "piece",
                                        unitLong: "piece",
                                        unitShort: "piece"
                                    )
                                    selectedIngredients.append(searchIngredient)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .onChange(of: searchText) { query in
            searchTimer?.invalidate()
            
            if query.count >= 3 {
                searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    store.dispatch(StoreAction.RecommendIngredient(name: query))
                }
            }
        }
        .onAppear {
            if store.state.ingredients.isEmpty {
                loadPopularIngredients()
            }
        }
    }
    
    private func loadPopularIngredients() {
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

// MARK: - Selection Ingredient Card
struct SelectionIngredientCard: View {
    let ingredient: IdentifiableIngredient
    let isSelected: Bool
    let onToggle: () -> Void
    
    private var categoryColor: Color {
        let name = ingredient.ingredient.name.lowercased()
        if name.contains("avocado") || name.contains("blueberry") {
            return .pink.opacity(0.7)
        } else if name.contains("tomato") {
            return .red.opacity(0.7)
        } else if name.contains("basil") {
            return .mint
        } else if name.contains("cheese") {
            return .yellow.opacity(0.7)
        } else if name.contains("salmon") {
            return .orange.opacity(0.7)
        } else {
            return .indigo.opacity(0.7)
        }
    }
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 8) {
                // Image
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(ingredient.ingredient.image)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
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
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .aspectRatio(1.25, contentMode: .fit)
                
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
            .frame(minWidth: 140, minHeight: 180)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.mint.opacity(0.4) : Color.black.opacity(0.5))
            )
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.mint : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
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

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
    }
}
