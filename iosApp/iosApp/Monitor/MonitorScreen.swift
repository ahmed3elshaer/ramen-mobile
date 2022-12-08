//
//  MonitorScreen.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/28/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI
import shared


struct MonitorScreen: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()

    var body: some View {
        Text(store.state.progress.description)
            .onAppear{
                store.dispatch(MonitorAction.StoreIngredient(autocompleteIngredient: AutocompleteIngredient_(id: 34532, image: "https://pngimg.com/uploads/carrot/carrot_PNG99134.png", name: "Carrots"), expiryDuration: 76699))
            }
    }
}

struct MonitorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MonitorScreen()
    }
}
