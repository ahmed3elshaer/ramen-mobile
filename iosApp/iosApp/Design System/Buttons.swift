//
//  Buttons.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

// MARK: - Custom Button Styles

struct ThemeButtonStyle: ButtonStyle {
    var color: Color
    var style: ThemeButton.Style
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        switch style {
        case .fill: return AnyView(FillButton(color: color, configuration: configuration))
        case .outline: return AnyView(OutlineButton(color: color, configuration: configuration))
        case .ghost: return AnyView(GhostButton(color: color, configuration: configuration))
        }
    }
    
    struct FillButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .typography(.s1)
                .foregroundColor(isEnabled ? .fontBtn : .fontDisabled)
                .padding()
                .frame(minHeight: 56)
                .background(isEnabled ? color : Color.basic.opacity(0.2))
                .cornerRadius(40)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
    
    struct OutlineButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .typography(.s1)
                .foregroundColor(isEnabled ? color : .fontDisabled)
                .padding()
                .frame(minHeight: 56)
                .background(isEnabled ? color.opacity(0.2) : Color.basic.opacity(0.15))
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(isEnabled ? color : Color.basic.opacity(0.5), lineWidth: 1)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
    
    struct GhostButton: View {
        var color: Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .typography(.s1)
                .foregroundColor(isEnabled ? color : .fontDisabled)
                .padding()
                .frame(minHeight: 56)
                .background(Color.white)
                .cornerRadius(40)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
    }
}

// MARK: - Usage

extension Button {
    /// Changes the appearance of the button
    func style(_ style: ThemeButton.Style, color: Color) -> some View {
        self.buttonStyle(ThemeButtonStyle(color: color, style: style))
    }
}

struct ThemeButton: View {
    
    enum Style {
        case fill, outline, ghost
    }
    
    var text: String?
    var image: Image?
    var style: Style = .fill
    var color: Color = .defaultPrimary
    var action: () -> Void
    var textAndImage: Bool { text != nil && image != nil }
    
    var body: some View {
        Button(action: action, label: {
            HStack() {
                Spacer()
                HStack(spacing: textAndImage ? 12 : 0) {
                    Text(text ?? "")
                    image
                }
                Spacer()
            }
        }).style(style, color: color)
    }
}


// MARK: - Preview

public struct Input_Previews: PreviewProvider {
    static let cloudImg = Image(systemName: "cloud.sun")
    
    public static var previews: some View {
        VStack(spacing: 40) {
            
            HStack(spacing: 5) {
                ThemeButton(text: "Fill", style: .fill, action: { print("click") })
                ThemeButton(text: "Outline", style: .outline, action: { print("click") })
                ThemeButton(text: "Ghost", style: .ghost, action: { print("click") })
            }
            
            HStack(spacing: 5) {
                ThemeButton(text: "Danger", color: .danger, action: { print("click") })
                ThemeButton(text: "Warning", color: .warning, action: { print("click") })
                ThemeButton(text: "Success", color: .success, action: { print("click") })
            }
            
            HStack(spacing: 5) {
                ThemeButton(text: "Disabled", style: .fill, action: { print("click") })
                    .disabled(true)
                ThemeButton(text: "Disabled", style: .outline, action: { print("click") })
                    .disabled(true)
                ThemeButton(text: "Disabled", style: .ghost, action: { print("click") })
                    .disabled(true)
            }
            
            HStack(spacing: 5) {
                ThemeButton(text: "Text", action: { print("click") })
                ThemeButton(text: "Text", image: cloudImg, action: { print("click") })
                ThemeButton(image: cloudImg, action: { print("click") })
            }
            
            Button(action: { print("click") }, label: { Text("Custom") })
                .style(.outline, color: .fontBtn)
        }
    .padding(10)
    }
}
