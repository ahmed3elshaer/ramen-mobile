//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI

struct StoredIngredientCard: View {
    
    var body: some View {
        VStack(){
            ZStack{
                Image("bricks_logo")
                    .circle(width: 54)
                
                CircularProgressView(progress: 0.25)
                    .frame(width: 86,height: 86)
            }
            .padding(4)
            .padding(.vertical,8)
            VStack(alignment: .center){
                // Name
                Text("Carrots")
                    .typography(.p2)
                    .padding(.vertical,4)
                HStack{
                    Text("9")
                        .typography(.p1)
                    Text("/18 Days")
                        .foregroundColor(Color.fontDisabled)
                        .typography(.p1)
                }
                .padding(.bottom , 4)
                
                
                
                
                
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal , 8)
            
        }
        .padding(16)
        .background(Color.surface)
        
        .cornerRadius(40)
    }
    
}

struct StoredIngredientCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            StoredIngredientCard()
            StoredIngredientCard()
        }
    }
    
}


