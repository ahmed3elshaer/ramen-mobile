import SwiftUI
import Shared

struct RecipeScreen: View {
    @SwiftUI.State private var selection: String? = nil
    @StateObject var store: RecipeStoreWrapper = RecipeStoreWrapper()
    let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]
    
    var body: some View {
        let recipes = store.state.searchRecipes.sorted { first, second in
            first.likes  > second.likes
        }

        NavigationView {
            ZStack{
                VStack {
                    Text("Recipes")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(recipes, id: \.self.hashValue) { recipe in
                                NavigationLink(
                                    destination: RecipeDetail(recipeId: recipe.id.description),
                                    tag: recipe.id.description,
                                    selection: $selection
                                ) {
                                    RecipeView(
                                        id: recipe.id.description,
                                        image: recipe.image,
                                        title: recipe.title,
                                        likes: recipe.likes,
                                        missingIngredients: recipe.missedIngredients
                                    )
                                    .onTapGesture {
                                        selection = recipe.id.description
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }.padding(.horizontal)
                }
            }
        }
        .background(Color.background)
        .onAppear {
            store.dispatch(RecipeAction.RecommendRecipes())
        }
    }
}

struct RecipeGridBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 18 / 255, green: 61 / 255, blue: 54 / 255), // Darker shade (#123D36)
                Color(red: 32 / 255, green: 110 / 255, blue: 99 / 255) // Lighter shade (#206E63)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea() // Extend the gradient to the entire screen
    }
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
    }
}
