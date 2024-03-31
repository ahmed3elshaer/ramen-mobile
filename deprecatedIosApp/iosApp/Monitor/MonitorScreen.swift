import Shared
import SwiftUI

struct MonitorScreen: View {
    @StateObject var store: MonitorStoreWrapper = .init()

    var body: some View {
        let ingredients: [Ingredient] = store.state.ingredients
        ScrollView {
            VStack {
                Text("Fridge Storage")
                    .typography(.h3)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 12) {
                    ForEach(ingredients, id: \.self.hashValue) { ingredient in
                        StoredIngredient(imageUrl: ingredient.image,
                                         name: ingredient.name,
                                         totalDays: ingredient.totalDurationInDays(),
                                         remaingDays: ingredient.durationUntilExpiry(),
                                         progress: ingredient.expiryProgress())
                    }
                }
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
