import SwiftUI

struct BatchAddView: View {
    @Binding var selectedIngredients: Set<IdentifiableIngredient>
    
    var body: some View {
        VStack {
            Text("Selected: \(selectedIngredients.count)")
                .typography(.h2)
            
            if !selectedIngredients.isEmpty {
                Button("Add All (\(selectedIngredients.count))") {
                    // Batch process all selected ingredients
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
} 
