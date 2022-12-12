import SwiftUI
import shared

struct MonitorScreen: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()
    
    var body: some View {
        let ingredients : [Ingredient_] = store.state.ingredients
        ScrollView{
            VStack{
                Text("Fridge Storage")
                    .typography(.h3)
                    .padding()
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                LazyVStack {
                    ForEach(ingredients,id: \.self.hashValue){ ingredient in
                        StoredIngredient(imageUrl: ingredient.image, name: ingredient.name,
                                             totalDays: ingredient.totalDurationInDays(),
                                             remaingDays:
                                                ingredient.durationUntilExpiry(),
                                             progress: ingredient.expiryProgress())
                    }}
            }
            .background(Color.background)
        }
        .onAppear{
            store.dispatch(MonitorAction.Refresh())
        }
    }
    
    private func storeIngredient(){
        //1000000000 and 2 are for Swift mapping to Duration Object
        let durationPerDay = 24 * 60 * 60 * 1000000000 * 2
        store.dispatch(MonitorAction.StoreIngredient(autocompleteIngredient: AutocompleteIngredient_(id: 9266, image: "https://loremflickr.com/640/480", name: "Carrot"), expiryDuration: Int64(10 * durationPerDay)))
        store.dispatch(MonitorAction.Refresh())
    }
    
    
}

struct MonitorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MonitorScreen()
    }
}
