//
//  RecipeDetail.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 3/14/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct RecipeDetail: View {
    let recipeId: String // A custom struct that holds the recipe data
    @SwiftUI.State private var selection :String? = nil

    @StateObject var store: RecipeDetailsStoreWrapper = RecipeDetailsStoreWrapper()
    var body: some View {
        let recipe = store.state.recipe
            ScrollView {
                VStack() {
                    // Show the photo of the recipe
                    AsyncImage(url: URL(string: recipe.image))
                    { imageView in
                        imageView
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                            .foregroundColor(Color.surface)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 25,style: .continuous))
                    
//                    // Show the title of the recipe
//                    Text(recipe.title)
//                        .typography(.h4)
//                        .font(.largeTitle)
//                        .foregroundStyle(
//                            LinearGradient(colors: [Color(hex: "D3F36B"),Color(hex: "7BD880"), Color(hex: "28B691"),Color(hex: "009191"),Color(hex: "176C7D"),Color(hex: "2F4858")],
//                                           startPoint: .leading,
//                                           endPoint: .trailing)
//                        )
//                        .fontWeight(.bold)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
                    Spacer()
                    
                    Text(recipe.summary)
                        .lineLimit(4)
                        .truncationMode(.tail)
                        .typography(.p3)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    RecipeSummary(recipe: recipe)
                    
                    Divider()
                    
                    Ingredients(recipe : recipe)
                    
                    Spacer()
                    if(!recipe.analyzedInstructions.isEmpty){
                        NavigationLink(destination: StepsView(recipe: recipe), tag: recipe.id.description, selection: $selection) {
                            ThemeButton(text : "Start Cooking") {
                                selection = recipe.id.description
                            }
                            .padding()
                        }
                    }
            }.onAppear{
                    store.dispatch(RecipeInfoAction.GetRecipeInfo(id: recipeId))
            }
        }
    }
}


struct Ingredients : View {
    let recipe : Recipe
    var body: some View{
        Divider()
        // Show a separate section for the ingredients
        LazyVStack(alignment: .leading) {
            
            Text("Ingredients")
                .typography(.h4)
                .padding([.top, .leading, .bottom])
            
            ForEach(recipe.extendedIngredients,id: \.self.hashValue) { ingredient in
                
                VStack(alignment: .leading) {
                    // Show the ingredient name and amount in a horizontal stack
                    HStack {
                        //
                        AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image))
                        { imageView in
                            imageView
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(4)
                            
                        } placeholder: {
                            ProgressView()
                                .foregroundColor(Color.surface)
                        }
                        .frame(width:50 , height: 50)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15 , style: .continuous))
                        .padding([.trailing])
                        
                        Text(ingredient.name.capitalized) // Ingredient name
                            .typography(.p2)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(ingredient.measures.metric.amount.description) \(ingredient.measures.metric.unitShort)") // Ingredient amount
                            .typography(.p2)
                            .font(.subheadline)
                    }
                    Divider()
                        .padding([.leading,.trailing])
                }.padding([.leading,.trailing])
                
            }
            
            
        }
    }
}

struct RecipeSummary : View {
    let recipe : Recipe
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Label("\(recipe.readyInMinutes) Minutes", systemImage: "clock")
                    .typography(.p2)
                
                Spacer()
                // Show the ingredients count
                Label("\(recipe.extendedIngredients.count) Ingredients", systemImage: "list.bullet")
                    .typography(.p2)
            }
            Spacer()
            VStack(alignment:.leading){
                // Show the number of steps
                Label("\(recipe.analyzedInstructions.first?.steps.count ?? 0) Steps", systemImage: "number")
                    .typography(.p2)
                
                Spacer()
                
                // Show the rating
                Label("\(recipe.healthScore) Points", systemImage: "arrow.up.heart")
                    .typography(.p2)
            }
            
            
        }
        .padding([.top, .leading, .trailing])
    }
}


struct Steps : View {
    let recipe : Recipe
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Steps")
                .typography(.h4)
                .padding([.top, .leading, .bottom])
            
            Spacer()
            
            ForEach(recipe.analyzedInstructions.indices,id: \.self.hashValue){ index in
                let instruction = recipe.analyzedInstructions[index]
                VStack(alignment: .leading){
                    Spacer()
                    TabView{
                        ForEach(instruction.steps, id: \.self.hashValue){ step in
                            ZStack {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.surface)
                                
                                VStack(alignment: .leading) {
                                    Text(step.number.description)
                                        .foregroundColor(Color.activePrimary)
                                        .typography(.h1)
                                        .padding([.bottom])
                                    
                                    Text(step.step)
                                        .typography(.p1)
                                        .padding([.bottom])
                                    
                                    HStack{
                                        ForEach(step.ingredients,id: \.self.hashValue) { ingredient in
                                            AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image))
                                            { imageView in
                                                imageView
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(4)
                                                
                                            } placeholder: {
                                                ProgressView()
                                                    .foregroundColor(Color.surface)
                                            }
                                            .frame(width:50 , height: 50)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 15 , style: .continuous))
                                            .padding([.trailing])
                                        }
                                    }
                                    
                                    HStack{
                                        ForEach(step.equipment,id: \.self.hashValue) { equipment in
                                            AsyncImage(url: URL(string: "https://spoonacular.com/cdn/equipment_100x100/" + equipment.image))
                                            { imageView in
                                                imageView
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .padding(4)
                                                
                                            } placeholder: {
                                                ProgressView()
                                                    .foregroundColor(Color.surface)
                                            }
                                            .frame(width:50 , height: 50)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 15 , style: .continuous))
                                            .padding([.trailing])
                                        }
                                    }
                                }
                                .frame(maxHeight : .infinity , alignment: .topLeading)
                                .padding()
                                
                            }
                            .frame(maxHeight : .infinity , alignment: .topLeading)
                            .padding()
                        }
                    }.tabViewStyle(.page)
                        .frame(height : 350)
                    
                }
            }
        }
    }
}
