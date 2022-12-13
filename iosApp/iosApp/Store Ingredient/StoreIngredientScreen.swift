//
//  StoreIngredientScreen.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/10/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import shared

struct StoreIngredientsScreen: View {
    @SwiftUI.State  var input:String = ""
    @SwiftUI.State  var selectingDuration:Bool = false
    @StateObject private var store: StoreIngredientWrapper = StoreIngredientWrapper()
    
    
    var body: some View {
        let recommendations = store.state.ingredients
        ScrollView{
            VStack{
                if #available(iOS 16.0, *) {
                    Text("Store Ingredient")
                        .typography(.h3)
                        .padding()
                        .frame(maxWidth: .infinity,alignment: .leading)
                }else{
                    Text("Store Ingredient")
                        .typography(.h3)
                        .padding()
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                
                TextField("Search for ingredient to store",
                          text: $input)
                .outlinedStyle()
                
                if(recommendations.count > 0){
                    Text("Matching ingredients")
                        .foregroundColor(Color.fontHint)
                        .typography(.c1)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
                LazyVStack {
                    ForEach(recommendations,id: \.self.hashValue){ ingredient in
                        AutocompleteIngredient(name: ingredient.name)
                            .onTapGesture {
                                selectingDuration = true
                            }
                            .sheet(isPresented: $selectingDuration) {
                                if #available(iOS 16.0, *) {
                                    DurationPicker { duration, unit in
                                        let durationPerDay = 24 * 60 * 60 * 1000000000 * 2
                                        let durationPerWeek = 24 * 60 * 60 * 1000000000 * 2 * 7
                                        let durationPerMonth = 24 * 60 * 60 * 1000000000 * 2 * 7 * 4
                                        var unitValue:Int {
                                            switch unit {
                                            case "Days" :
                                                return durationPerDay
                                            case "Weeks" :
                                                return durationPerWeek
                                            case "Months" :
                                                return durationPerMonth
                                            default :
                                                return durationPerDay
                                            }
                                        }
                                        store.dispatch(StoreAction.StoreIngredient(autocompleteIngredient: ingredient, expiryDuration: Int64(unitValue * duration)))
                                        selectingDuration = false
                                    }
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                    }
                    
                }
                .frame(maxHeight: .infinity)
                .onChange(of: input, perform: { _ in
                    if(!input.isEmpty && input.count > 2){
                        store.dispatch(StoreAction.RecommendIngredient(name: input))
                        
                    }
                })
            }
            
        }
        
    }
}


@available(iOS 16.0, *)
struct DurationPicker : View {
    @SwiftUI.State private var durationNumber: String = ""
    @SwiftUI.State private var unit: String = "Days"
    let onDurationSelected : (Int , String) -> ()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing : 8) {
            HStack{
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.danger)
                .frame(maxWidth: .infinity,alignment: .leading)
                
                Text("Expiry Duration ")
                    .typography(.s2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,alignment: .center)
                
                Button("Add") {
                    onDurationSelected(Int(durationNumber)!,unit)
                }
                .foregroundColor(.defaultPrimary)
                .frame(maxWidth: .infinity,alignment: .trailing)
                
            }
            .padding()
            
            
            Text("\(durationNumber) \(unit)")
                .typography(.h5)
                .lineLimit(1)
                .frame(maxWidth: .infinity,alignment: .center)
                .padding()
            
            TextField("Duration",
                      text: $durationNumber,
                      onCommit: {
                onDurationSelected(Int(durationNumber)!,unit)
            })
            .outlinedStyle()
            .keyboardType(.numberPad)
            .padding(16)
            .accentColor(Color.defaultPrimary)
            
            
            HStack(){
                ThemeButton(text: "Days"
                            ,style: unit == "Days" ? .fill : .outline,
                            action: {unit = "Days"}
                )
                ThemeButton(text: "Weeks"
                            ,style: unit == "Weeks" ? .fill : .outline,
                            action: {unit = "Weeks"}
                )
                ThemeButton(text: "Months"
                            ,style: unit == "Months" ? .fill : .outline,
                            action: {unit = "Months"}
                )
            }
            .padding(.horizontal , 16)
            Spacer()
        }
        .presentationDetents([.medium,.large])
    }
}

struct StoreIngredientScreen_Previews: PreviewProvider {
    static var previews: some View {
        StoreIngredientsScreen()
    }
    
}

struct DuraionPicker_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            DurationPicker(onDurationSelected: { Int, String in
                
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
}
