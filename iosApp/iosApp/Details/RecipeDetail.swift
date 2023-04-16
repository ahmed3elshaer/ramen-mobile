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
    
    @StateObject var store: RecipeDetailsStoreWrapper = RecipeDetailsStoreWrapper()
    var body: some View {
        let recipe = store.state.recipe
        ScrollView {
            VStack() {
                // Show the photo of the recipe
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                // Show the title of the recipe
                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Show some basic info about the recipe
                VStack {
                    // Show the preparation time
                    Label("\(recipe.readyInMinutes) min", systemImage: "clock")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Show the ingredients count
                    Label("\(recipe.extendedIngredients.count) ingredients", systemImage: "list.bullet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()a
                    
                    // Show the number of steps
                    Label("\(recipe.analyzedInstructions.first?.steps.count ?? 0) steps", systemImage: "number")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Show the rating
                    Label("\(recipe.healthScore)", systemImage: "star.fill")
                        .font(.headline)
                    
                }
                
                Divider()
                
                // Show a separate section for the ingredients
                LazyVStack(alignment: .leading) {
                    
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.top, .leading])
                    
                    ForEach(recipe.extendedIngredients,id: \.self.hashValue) { ingredient in
                        
                        VStack(alignment: .leading) {
                            // Show the ingredient name and amount in a horizontal stack
                            HStack {
                                Text(ingredient.name.capitalized) // Ingredient name
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Text(ingredient.measures.metric.amount.description) // Ingredient amount
                                    .font(.subheadline)
                            }
                            
                        }.padding([.leading,.trailing])
                        
                    }
                    
                    Divider()
                    
                }
                //Show a separate section for step by step preparation
                VStack(alignment:.leading){
                    Text("Steps")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding([.top,.leading])
                    Spacer()
                    ForEach(recipe.analyzedInstructions.indices,id: \.self.hashValue){ index in
                        let instruction = recipe.analyzedInstructions[index]
                        VStack(alignment: .leading){
                            Spacer()
                            ForEach(instruction.steps.indices, id: \.self.hashValue){ stepIndex in
                                Text((stepIndex+1).description+") "+instruction.steps[stepIndex].step.description)
                                    .font(.body)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }.navigationTitle(recipe.title)
            .onAppear{
                store.dispatch(RecipeInfoAction.GetRecipeInfo(id: recipeId))
            }
        
    }
}
