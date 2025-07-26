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
    
    // MARK: Enhanced Gradient Colors for Liquid Glass
    
    /// Darker Mint (#6BA88A) - Enhanced for dark mode
    static let darkMint = Color(hex: "6BA88A")
    /// Deep Green (#7A9B6E) - Enhanced for dark mode  
    static let deepGreen = Color(hex: "7A9B6E")
    /// Ocean Blue (#8BB8B3) - Enhanced for dark mode
    static let oceanBlue = Color(hex: "8BB8B3")
    /// Forest Green (#5D8A5D) - Enhanced for dark mode
    static let forestGreen = Color(hex: "5D8A5D")
    
    // MARK: Liquid Glass Material Colors
    
    /// Primary Glass Background
    static let glassBackground = Color.primary.opacity(0.02)
    /// Secondary Glass Background  
    static let glassSecondaryBackground = Color.secondary.opacity(0.05)
    /// Glass Border
    static let glassBorder = Color.primary.opacity(0.1)
    /// Glass Highlight
    static let glassHighlight = Color.white.opacity(0.15)
    
    // MARK: Status Colors with Glass Enhancement
    
    /// Fresh State Colors
    static let freshPrimary = Color.adaptive(light: deepGreen, dark: darkMint)
    static let freshSecondary = Color.adaptive(light: laurelGreen, dark: forestGreen)
    static let freshBackground = Color.adaptive(light: deepGreen.opacity(0.08), dark: darkMint.opacity(0.12))
    
    /// Expiring Soon State Colors
    static let expiringSoonPrimary = Color.adaptive(light: lemonMeringue, dark: Color(hex: "D4A574"))
    static let expiringSoonSecondary = Color.adaptive(light: Color(hex: "F0D785"), dark: Color(hex: "B8934A"))
    static let expiringSoonBackground = Color.adaptive(light: lemonMeringue.opacity(0.08), dark: Color(hex: "D4A574").opacity(0.12))
    
    /// Expired State Colors
    static let expiredPrimary = Color.adaptive(light: copper, dark: Color(hex: "C76B47"))
    static let expiredSecondary = Color.adaptive(light: pastelPink, dark: Color(hex: "B5785D"))
    static let expiredBackground = Color.adaptive(light: copper.opacity(0.08), dark: Color(hex: "C76B47").opacity(0.12))
    
    // MARK: Basic Colors
    
    static let background = Color.adaptive(light: .white, dark: Color(hex: "0A0A0A"))
    static let surface = Color.adaptive(light: .white, dark: Color(hex: "1C1C1E"))
    static let basic = Color.adaptive(light: Color.gray.opacity(0.5), dark: Color.gray.opacity(0.7))
    static let defaultPrimary = pastelBlue
    
    // MARK: Font Colors
    
    /// Standard Font Color
    static let fontStd = Color.adaptive(light: .black, dark: .white)
    /// Hint Font Color
    static let fontHint = Color.adaptive(light: .gray, dark: Color.gray.opacity(0.8))
    /// Disabled Font Color
    static let fontDisabled = Color.adaptive(light: Color.gray.opacity(0.5), dark: Color.gray.opacity(0.6))
    /// Button Font Color
    static let fontBtn = Color.white
    
    // MARK: Semantic Colors
    
    static let danger = Color.adaptive(light: copper, dark: expiredPrimary)
    static let info = Color.adaptive(light: pastelBlue, dark: oceanBlue)
    static let success = Color.adaptive(light: laurelGreen, dark: freshPrimary)
    static let warning = Color.adaptive(light: lemonMeringue, dark: expiringSoonPrimary)
    
    // MARK: State Colors
    
    /// Active State Color - Primary Style
    static let activePrimary = Color.adaptive(light: pastelBlue, dark: oceanBlue)
    /// Active State Color - Basic Style
    static let activeBasic = Color.adaptive(light: pastelPink, dark: expiredSecondary)
    
    // MARK: Helper Methods
    
    /// Creates adaptive color for light/dark mode
    static func adaptive(light: Color, dark: Color) -> Color {
        Color(.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
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
