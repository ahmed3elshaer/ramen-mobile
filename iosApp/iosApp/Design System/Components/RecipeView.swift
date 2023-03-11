//
//  RecipeView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/12/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct RecipeView: View {
    let image :String
    let title :String
    let missingIngredients : [SearchRecipe.Ingredient]

    var body: some View {
        VStack{
            
            ZStack{
                    AsyncImage(url: URL(string: image)!)
                    { imageView in
                        imageView
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 25,style: .continuous))
                    
                    VStack(spacing: 0){
                        Spacer()
                            .frame(height: 8)
                        Text(title)
                            .typography(.h5)
                            .padding(.horizontal,16)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        Spacer()
                            .frame(height: 8)
                        if(missingIngredients.count > 0 ){
                            HStack(){
                                Text("Missing (\(missingIngredients.count)) : \(missingIngredients.map{ ingredient in ingredient.name}.joined(separator: ", "))")
                                    .typography(.p3)
                                    .padding(.horizontal,16)
                            }  .frame(maxWidth: .infinity,alignment: .leading)
                            
                        } else{
                            Text("All ingredients included")
                                .typography(.p3)
                                .foregroundColor(.fontBtn)
                                .frame(width: .infinity, alignment: .leading)
                                .padding(.horizontal,16)
                        }
                        
                        
                        Spacer()
                            .frame(height: 8)
                        
                        
                        
                    }
                    .background(.ultraThickMaterial)
                    .frame(maxHeight:.infinity ,alignment: .bottom)
                }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal,16)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(image: "https://spoonacular.com/recipeImages/716429-556x370.jpg",
                   title: "Apple Or Peach Strudel",
                   missingIngredients: [SearchRecipe.Ingredient]())
    }
}
