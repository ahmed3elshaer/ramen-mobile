//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI

struct AutocompleteIngredientView: View {
    let name:String
    
    var body: some View {
            Text(name)
                .typography(.s1)
                .foregroundColor(.pastelBlue)
                .lineLimit(1)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.lemonMeringue.opacity(0.1))
                .cornerRadius(8)
    }
    
}

struct AutocompleteIngredient_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AutocompleteIngredientView(
                             name: "Durgan"
            )
            AutocompleteIngredientView(
                             name: "Durgan"
            )
            AutocompleteIngredientView(
                             name: "Durgan"
            )
            
            AutocompleteIngredientView(
                             name: "Durgan"
            )
            AutocompleteIngredientView(
                             name: "Durgan"
            )
        }
    }
    
}


