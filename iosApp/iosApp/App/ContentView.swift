import SwiftUI
import shared

struct HomeScreen: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()
    
    let greet = "Hello"
    
    var body: some View {
        
        let ingredients : [Ingredient_] = store.state.ingredients
        VStack{
            ScrollView{
                VStack(spacing: 16){
                    Spacer(minLength: 40)
                    
                    Text(store.sideEffect?.description ?? "")
                    Text("Fridge Storage")
                        .typography(.h2)
                        .padding()
                        .frame(maxWidth: .infinity , alignment: .leading)
                    
                    ThemeButton(text: "Store Ingredient",
                                image: Image(systemName: "plus.circle"),
                                style: .fill,
                                action :{ storeIngredient()}
                    )
                    
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    LazyVStack {
                        ForEach(ingredients,id: \.self.hashValue){ ingredient in
                            StoredIngredientCard(imageUrl: ingredient.image, name: ingredient.name,
                                                 totalDays: ingredient.totalDurationInDays(),
                                                 remaingDays:
                                                    ingredient.durationUntilExpiry(),
                                                 progress: ingredient.expiryProgress())
                        }}
                    
                }
                .padding(16)
            }
        }
        .onAppear{
            store.dispatch(MonitorAction.Refresh())
        }
        
    }
    
    private func storeIngredient(){
        //1000000000 and 2 are for Swift
        let durationPerDay = 24 * 60 * 60 * 1000000000 * 2
        store.dispatch(MonitorAction.StoreIngredient(autocompleteIngredient: AutocompleteIngredient_(id: 9266, image: "https://loremflickr.com/640/480", name: "Carrot"), expiryDuration: Int64(10 * durationPerDay)))
        store.dispatch(MonitorAction.Refresh())
    }
    
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
