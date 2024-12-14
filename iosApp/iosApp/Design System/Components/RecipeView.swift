//
//  RecipeView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/12/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

import SDWebImageSwiftUI
import Shared

struct RecipeView: View {
    var id: String
    var image: String
    var title: String
    var likes: Int32
    let missingIngredients: [SearchRecipe.Ingredient]
    
    var body: some View {
          ZStack {
              RoundedRectangle(cornerRadius: 16)
                  .fill(.clear)
                  .background(.thinMaterial)
                  .clipShape(RoundedRectangle(cornerRadius: 16))
                  .shadow(radius: 4)
              
              VStack {
                  WebImage(url: URL(string: image))
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(height: 100)
                      .clipShape(Circle())
                      .overlay(
                          Circle()
                              .stroke(Color.white, lineWidth: 3)
                      )
                  
                  Text(title)
                      .font(.headline)
                      .fontWeight(.bold)
                      .multilineTextAlignment(.center)
                      .padding(.top, 8)
                      .lineLimit(2)
                  
                  HStack(spacing: 16) {
                      // Number of likes
                      HStack(spacing: 4) {
                          Image(systemName: "heart.fill")
                              .font(.subheadline)
                              .foregroundColor(.red)
                          Text("\(likes)")
                              .font(.subheadline)
                      }
                      
                      // Number of missing ingredients
                      HStack(spacing: 4) {
                          Image(systemName: "cart.badge.minus")
                              .font(.subheadline)
                          Text("\(missingIngredients.count)")
                              .font(.subheadline)
                      }
                  }
                  .padding(.top, 4)
              }
              .padding()
          }
      }
  }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(id: "id1",
                   image: "https://loremflickr.com/640/480/fashion",
                   title: "Sample Title",
                   likes: 3,
                   missingIngredients: generateMissingIngredients())
    }
    
    private static func createIngredient(name: String) -> SearchRecipe.Ingredient {
        return SearchRecipe.Ingredient(
            aisle: "",
            amount: 2.0,
            id: 1,
            image: "",
            name: name,
            original: "",
            originalName: "",
            unit: "",
            unitLong: "",
            unitShort: "")
    }
    
    private static func generateMissingIngredients() -> [SearchRecipe.Ingredient] {
        return ["Item 1", "Item 2", "Item 3"].map {
            createIngredient(name: $0)
        }
    }
}
