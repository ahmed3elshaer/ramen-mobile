import SwiftUI
import Shared

struct MonitorScreen: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()
    @Environment(\.colorScheme) var colorScheme
    @SwiftUI.State private var isStoreIngredientSheetPresented = false
    
    var body: some View {
        let ingredients: [Ingredient] = store.state.ingredients
        
        ZStack {
            // MARK: - Full-Screen Gradient Background
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
            .ignoresSafeArea(.all)
            
            // MARK: - Subtle Radial Gradient Overlay
            RadialGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [
                    Color.darkMint.opacity(0.1),
                    Color.clear
                ] : [
                    Color.pastelBlue.opacity(0.2),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea(.all)
            
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Header card with enhanced design
                        FridgeHeaderCard(
                            freshCount: calculateFreshCount(ingredients),
                            expiringSoonCount: calculateExpiringSoonCount(ingredients),
                            expiredCount: calculateExpiredCount(ingredients)
                        )
                        .padding(.horizontal, 20)
                        
                        // Ingredients list with full-width liquid glass cards
                        if !ingredients.isEmpty {
                            LazyVStack(spacing: 16) {
                                ForEach(ingredients, id: \.id) { ingredient in
                                    LiquidGlassIngredientCard(ingredient: ingredient)
                                        .padding(.horizontal, 20)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)
                                        ))
                                }
                            }
                            .animation(.easeInOut(duration: 0.3), value: ingredients.count)
                        } else {
                            // Enhanced empty state with liquid glass styling
                            VStack(spacing: 20) {
                                Image(systemName: "refrigerator")
                                    .font(.system(size: 70))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.fontHint.opacity(0.6), Color.fontHint.opacity(0.3)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                
                                VStack(spacing: 8) {
                                    Text("Your fridge is empty")
                                        .typography(.h4)
                                        .foregroundColor(.fontStd)
                                    
                                    Text("Add ingredients to start tracking their freshness")
                                        .typography(.p3)
                                        .foregroundColor(.fontHint)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.vertical, 50)
                            .padding(.horizontal, 30)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Add bottom padding for floating button
                }
                .refreshable {
                    // Pull to refresh functionality
                    store.dispatch(MonitorAction.Refresh())
                }
            }
            
            // MARK: - Floating Action Button (Always Visible)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButton {
                        isStoreIngredientSheetPresented = true
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isStoreIngredientSheetPresented) {
            StoreIngredientBottomSheet(isPresented: $isStoreIngredientSheetPresented)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            store.dispatch(MonitorAction.Refresh())
        }
    }
    
    // MARK: - Helper Methods
    
    private func calculateFreshCount(_ ingredients: [Ingredient]) -> Int {
        return ingredients.filter { ingredient in
            ingredient.getExpiryState() == .fresh
        }.count
    }
    
    private func calculateExpiringSoonCount(_ ingredients: [Ingredient]) -> Int {
        return ingredients.filter { ingredient in
            ingredient.getExpiryState() == .expiringSoon
        }.count
    }
    
    private func calculateExpiredCount(_ ingredients: [Ingredient]) -> Int {
        return ingredients.filter { ingredient in
            ingredient.getExpiryState() == .expired
        }.count
    }
}

// MARK: - Preview

struct MonitorScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonitorScreen()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            MonitorScreen()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
