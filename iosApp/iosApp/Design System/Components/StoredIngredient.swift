//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI

struct StoredIngredient: View {
    let imageUrl:String
    let name:String
    let totalDays:String
    let remaingDays:String
    let progress:Double
    
    
    
    init(imageUrl: String, name: String, totalDays: String, remaingDays: String, progress: Double) {
        self.imageUrl = imageUrl
        self.name = name
        self.totalDays = totalDays
        self.remaingDays = remaingDays
        self.progress = progress
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle()
                    .fill( Color.surface)
                    .cornerRadius(54)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                Rectangle()
                    .fill( LinearGradient(colors: [Color.defaultPrimary.opacity(0.2), Color.defaultPrimary.opacity(0.7)],
                                          startPoint: .leading,
                                          endPoint: .trailing)
                    )
                    .frame(width: min(progress*geometry.size.width, geometry.size.width),height: 54)
                    .cornerRadius(54)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                
                HStack(){
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: URL(string:"https://spoonacular.com/cdn/ingredients_100x100/\(imageUrl)")!){ image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 54, height: 54)
                        .background(Color.gray)
                        .clipShape(Circle())
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                    Text(name)
                        .typography(.p2)
                        .lineLimit(2)
                    
                    Text("\(remaingDays.description) of \(totalDays)")
                        .typography(.s2)
                        .frame(maxWidth: .infinity,alignment: .trailing)
                        .padding()
                    
                }
            }
            
        }
        .frame(height: 54)
        .padding(8)
    }
    
}

struct StoredIngredientCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            StoredIngredient(imageUrl: "https://loremflickr.com/640/480",
                                 name: "Durgan",
                                 totalDays: "7",
                                 remaingDays: "3",
                                 progress: 0.55)
            StoredIngredient(imageUrl: "https://loremflickr.com/640/480/food",
                                 name: "Mosciski",
                                 totalDays: "20",
                                 remaingDays: "10",
                                 progress: 0.25)
        }
    }
    
}


