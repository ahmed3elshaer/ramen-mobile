import SwiftUI
import shared

struct RecipeScreen: View {
    @StateObject var store: RecipeStoreWrapper = RecipeStoreWrapper()
    @State var selectedRecipe : String? = nil
    
    var body: some View {
        let recipes = store.state.searchRecipes.sorted {first , second in
            first.missedIngredients.count < second.missedIngredients.count
        }
        NavigationView {
            NavigationLink(destination: RecipeDetail(recipeId: recipe.id.description)) {
                ScrollView{
                    VStack{
                        Text("Recipes")
                            .typography(.h3)
                            .padding()
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        
                        LazyVStack(spacing: 8) {
                            ForEach(recipes,id: \.self.hashValue){ recipe in
                                RecipeView(id: recipe.id.description,
                                           image: recipe.image,
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
    }
    
    
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
    }
}
