//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI

struct StoredIngredientCard: View {
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
        
        print("🥗 totalDays \(totalDays)")
        print("🥗 remaingDays \(remaingDays)")
        print("🥗 progress \(progress)")
    }
    
    var body: some View {
        VStack(){
            ZStack{
                
                UrlImage(url: URL(string:"https://spoonacular.com/cdn/ingredients_250x250/\(imageUrl)")!,
                         placeholder: { Text("Loading")},
                         image : {Image(uiImage: $0).resizable() })
                .circle(width: 32)
                
            }
            .padding(4)
            .padding(.vertical,8)
            VStack(alignment: .center){
                // Name
                Text(name)
                    .typography(.p2)
                    .padding(.vertical,4)
                HStack{
                    Text(remaingDays.description)
                        .typography(.p1)
                    Text("/\(totalDays) Days")
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
    }
    
}

struct StoredIngredientCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            StoredIngredientCard(imageUrl: "https://loremflickr.com/640/480",
                                 name: "Durgan",
                                 totalDays: "7",
                                 remaingDays: "3",
                                 progress: 0.55)
            StoredIngredientCard(imageUrl: "https://loremflickr.com/640/480/food",
                                 name: "Mosciski",
                                 totalDays: "20",
                                 remaingDays: "10",
                                 progress: 0.25)
        }
    }
    
}


