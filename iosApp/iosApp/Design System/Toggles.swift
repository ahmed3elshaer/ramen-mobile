//
//  Toggles.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

public struct ThemeToggle: View {
    
    enum Style {
        case defaultStyle, primary, disabled, success, warning, danger, info
    }
    
    @State var toggleState: Bool = true
    var style: Style
    
    struct ColoredToggleStyle: ToggleStyle {
        var onColor = Color.defaultPrimary
        var offColor = Color.danger
        var thumbColor = Color.white
        
        func makeBody(configuration: Self.Configuration) -> some View {
            Button(action: { configuration.isOn.toggle() } ) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(thumbColor)
                                .shadow(radius: 1, x: 0, y: 1)
                                .padding(1.5)
                                .offset(x: configuration.isOn ? 10 : -10)
                            Image(systemName: configuration.isOn ? "checkmark" : "")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(onColor)
                                .offset(x: configuration.isOn ? 10 : -10)
                            
                        }
                    )
                    .animation(.easeInOut(duration: 0.1))
            }
            .font(.title)
            .padding(.horizontal)
        }
    }
    
    
    public var body: some View {
        switch style {
        case .primary: return AnyView(primary())
        case .success: return AnyView(success())
        case .warning: return AnyView(warning())
        case .danger: return AnyView(danger())
        case .info: return AnyView(info())
        default: return AnyView(defaultStyle())
        }
    }
    
    
    fileprivate func defaultStyle() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .basic,
                    offColor: Color.basic.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func primary() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .defaultPrimary,
                    offColor: Color.defaultPrimary.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func success() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .success,
                    offColor: Color.success.opacity(0.1),
                    thumbColor: .white))
    }
    
    fileprivate func info() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .info,
                    offColor: Color.info.opacity(0.1),
                    thumbColor: .white))
    }
    
    
    fileprivate func warning() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .warning,
                    offColor: Color.warning.opacity(0.1),
                    thumbColor: .white))
    }
    
    
    fileprivate func danger() -> some View {
        Toggle("", isOn: $toggleState)
            .toggleStyle(
                ColoredToggleStyle(
                    onColor: .danger,
                    offColor: Color.danger.opacity(0.1),
                    thumbColor: .white))
    }
}

struct Toggles_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ThemeToggle(style: .defaultStyle)
            ThemeToggle(style: .primary)
            ThemeToggle(style: .success)
            ThemeToggle(style: .info)
            ThemeToggle(style: .warning)
            ThemeToggle(style: .danger)
        }
    }
}
