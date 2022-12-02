//
//  VisualEffect.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/1/22.
//  Copyright © 2022 orgName. All rights reserved.
//
import SwiftUI
struct VisualEffect: UIViewRepresentable {
    @State var style : UIBlurEffect.Style // 1
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style)) // 2
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    } // 3
}
