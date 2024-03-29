//
//  Typography.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

extension Color {
    
    // MARK: Basic Colors
    
    static let background = Color("background")
    static let surface = Color("surface")
    static let basic = Color("basic")
    static let defaultPrimary = Color("primary")
    
    // MARK: Font Colors
    
    /// Standard Font Color
    static let fontStd = Color("font_std")
    /// Hint Font Color
    static let fontHint = Color("font_hint")
    /// Disabled Font Color
    static let fontDisabled = Color("font_disabled")
    /// Button Font Color
    static let fontBtn = Color("font_button")
    
    // MARK: Semantic Colors
    
    static let danger = Color("danger")
    static let info = Color("info")
    static let success = Color("success")
    static let warning = Color("warning")
    
    // MARK: State Colors
    
    /// Active State Color - Primary Style
    static let activePrimary = Color("activePrimary")
    /// Active State Color - Basic Style
    static let activeBasic = Color("activeBasic")
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack{
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.basic)
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.defaultPrimary)
                Rectangle().size(CGSize(width: 50, height: 50))
                    .foregroundColor(.success)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.info)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.warning)
                Rectangle().size(CGSize(width: 50, height: 50))
                .foregroundColor(.danger)
            }
            Text("Hello, World!")
                .foregroundColor(.activePrimary)
                .background(Color.activeBasic)
                .environment(\.colorScheme, .dark)
        }
    .padding()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            .sRGB,
            red: Double(r) / 0xff,
            green: Double(g) / 0xff,
            blue: Double(b) / 0xff,
            opacity: 1
        )
    }
}
