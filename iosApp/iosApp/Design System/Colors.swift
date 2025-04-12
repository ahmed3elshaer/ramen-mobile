//
//  Typography.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

extension Color {
    
    // MARK: New Color Palette
    
    /// Pastel Blue (#ADD6CF)
    static let pastelBlue = Color(hex: "ADD6CF")
    /// Laurel Green (#9FB693)
    static let laurelGreen = Color(hex: "9FB693")
    /// Lemon Meringue (#F8E8C4)
    static let lemonMeringue = Color(hex: "F8E8C4")
    /// Pastel Pink (#F0AF9E)
    static let pastelPink = Color(hex: "F0AF9E")
    /// Copper (#E48364)
    static let copper = Color(hex: "E48364")
    
    // MARK: Basic Colors
    
    static let background = Color.white
    static let surface = Color.white
    static let basic = Color.gray.opacity(0.5)
    static let defaultPrimary = pastelBlue
    
    // MARK: Font Colors
    
    /// Standard Font Color
    static let fontStd = Color.black
    /// Hint Font Color
    static let fontHint = Color.gray
    /// Disabled Font Color
    static let fontDisabled = Color.gray.opacity(0.5)
    /// Button Font Color
    static let fontBtn = Color.white
    
    // MARK: Semantic Colors
    
    static let danger = copper
    static let info = pastelBlue
    static let success = laurelGreen
    static let warning = lemonMeringue
    
    // MARK: State Colors
    
    /// Active State Color - Primary Style
    static let activePrimary = pastelBlue
    /// Active State Color - Basic Style
    static let activeBasic = pastelPink
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
