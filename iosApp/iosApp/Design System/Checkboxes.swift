//
//  Toggles.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI


public struct ThemeCheckbox: View {
    
    enum Style {
        case defaultStyle, primary, disabled, success, warning, danger, info
    }
    
    @State var checkboxState: Bool = true
    var style: Style
    
    struct ColoredCheckboxStyle: ToggleStyle {
        var onColor = Color.defaultPrimary
        var offColor = Color.fontDisabled
        
        func makeBody(configuration: Self.Configuration) -> some View {
            return HStack {
                configuration.label
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .onTapGesture { configuration.isOn.toggle() }
                .foregroundColor(configuration.isOn ? onColor : offColor)
            }
            
        }
    }
    
    
    public var body: some View {
        switch style {
        case .success: return AnyView(success())
        case .primary: return AnyView(primary())
        case .warning: return AnyView(warning())
        case .danger: return AnyView(danger())
        case .info: return AnyView(info())
        default: return AnyView(defaultStyle())
        }
    }
    
    
    fileprivate func defaultStyle() -> some View {
        Toggle("", isOn: $checkboxState)
            .toggleStyle(ColoredCheckboxStyle(onColor: .basic, offColor: .fontDisabled))
    }
    
    fileprivate func primary() -> some View {
        Toggle("", isOn: $checkboxState)
            .toggleStyle(ColoredCheckboxStyle(onColor: .defaultPrimary, offColor: .fontDisabled))
    }
    
    fileprivate func success() -> some View {
            Toggle("", isOn: $checkboxState)
            .toggleStyle(ColoredCheckboxStyle(onColor: .success, offColor: .fontDisabled))
    }
    
    fileprivate func info() -> some View {
        Toggle("", isOn: $checkboxState)
        .toggleStyle(ColoredCheckboxStyle(onColor: .info, offColor: .fontDisabled))
    }
    
    
    fileprivate func warning() -> some View {
        Toggle("", isOn: $checkboxState)
        .toggleStyle(ColoredCheckboxStyle(onColor: .warning, offColor: .fontDisabled))
    }
    
    
    fileprivate func danger() -> some View {
        Toggle("", isOn: $checkboxState)
        .toggleStyle(ColoredCheckboxStyle(onColor: .danger, offColor: .fontDisabled))
    }
}


struct Checkboxes_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10){
            ThemeCheckbox(checkboxState: true, style: .defaultStyle)
            ThemeCheckbox(checkboxState: true, style: .primary)
            ThemeCheckbox(checkboxState: true, style: .success)
            ThemeCheckbox(checkboxState: true, style: .info)
            ThemeCheckbox(checkboxState: true, style: .warning)
            ThemeCheckbox(checkboxState: true, style: .danger)
        }
    }
}
