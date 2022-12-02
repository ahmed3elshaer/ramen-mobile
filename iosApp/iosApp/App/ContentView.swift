import SwiftUI
import shared

struct ContentView: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()
    
    let greet = "Hello"
    
    var body: some View {
            VStack{
                ScrollView{
                    VStack(spacing: 16){
                        Spacer(minLength: 40)
                        
                        
                        Text("Fridge Storage")
                            .typography(.h2)
                            .padding()
                            .frame(maxWidth: .infinity , alignment: .leading)
                        ThemeButton(text: "Store Ingredient", image: Image(systemName: "plus.circle"), style: .fill,action :{})
                        HStack(spacing: 16){
                            StoredIngredientCard()
                            StoredIngredientCard()
                        }
                        HStack(spacing: 16){
                            StoredIngredientCard()
                            StoredIngredientCard()
                        }
                        HStack(spacing: 16){
                            StoredIngredientCard()
                            StoredIngredientCard()
                            
                        }
                        StoredIngredientCard()
                        
                        
                        NavigatorBottom(index: 0, icons: ["",""])
                    }
                    .padding(16)
                }
                .background(Color.background)
                
                NavigatorBottom(index: 0, icons: ["house.fill", "magnifyingglass", "heart.fill", "person.fill"])
            }
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
