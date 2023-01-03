import SwiftUI
import shared

struct RecipeScreen: View {
    @StateObject var store: RecipeStoreWrapper = RecipeStoreWrapper()
    
    var body: some View {
        let recipes = store.state.searchRecipes.sorted {first , second in
            first.missedIngredients.count < second.missedIngredients.count
        }
        ScrollView{
            VStack{
                Text("Recipes")
                    .typography(.h3)
                    .padding()
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                LazyVStack(spacing: 8) {
                    ForEach(recipes,id: \.self.hashValue){ recipe in
                        RecipeView(image: recipe.image,
                                   title: recipe.title,
                                   missingIngredients: recipe.missedIngredients
                                            )
                    }}
            }
        }
        .onAppear{
            store.dispatch(RecipeAction.RecommendRecipes())
        }
    }
    
    
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
    }
}
