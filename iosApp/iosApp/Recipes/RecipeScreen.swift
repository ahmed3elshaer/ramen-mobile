import SwiftUI
import shared

struct RecipeScreen: View {
    @SwiftUI.State private var selection :String? = nil
    @StateObject var store: RecipeStoreWrapper = RecipeStoreWrapper()
    
    var body: some View {
        let recipes = store.state.searchRecipes.sorted {first , second in
            first.missedIngredients.count < second.missedIngredients.count
        }
        NavigationView {
            VStack{
                Text("Recipes")
                    .typography(.h3)
                    .frame(maxWidth: .infinity,alignment: .leading)
                ScrollView{
                    ForEach(recipes,id: \.self.hashValue){ recipe in
                        NavigationLink(destination: RecipeDetail(recipeId: recipe.id.description), tag: recipe.id.description, selection: $selection) {
                            RecipeView(id: recipe.id.description,
                                       image: recipe.image,
                                       title: recipe.title,
                                       missingIngredients: recipe.missedIngredients)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selection = recipe.id.description
                            }
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
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
