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

    let greet = "Hello"

    var body: some View {
        Text(store.state.progress.description)
    }
}

struct MonitorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MonitorScreen()
    }
}
