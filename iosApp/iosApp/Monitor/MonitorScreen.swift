import SwiftUI
import Shared

struct MonitorScreen: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()
    private let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 16)
    ]
    
    
    var body: some View {
        let ingredients: [Ingredient] = store.state.ingredients
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Fridge Storage")
                    .typography(.h3)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ingredients, id: \.self.hashValue) { ingredient in
                        StoredIngredient(
                            imageUrl: ingredient.image,
                            name: ingredient.name,
                            totalDays: ingredient.totalDurationInDays(),
                            remaingDays: ingredient.durationUntilExpiry(),
                            progress: ingredient.expiryProgress()
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.background)
        }
        .onAppear {
            store.dispatch(MonitorAction.Refresh())
        }
    }
    
}

struct MonitorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MonitorScreen()
    }
}
