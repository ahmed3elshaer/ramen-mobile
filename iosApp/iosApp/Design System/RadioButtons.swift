//
//  RadioButton.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

public struct RadioButton: View {
    var isChecked: Bool
    var color: Color?
    var text: String = ""
    
    private var colorToUse: Color? { isEnabled ? color : .fontDisabled }
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public var body: some View {
        HStack(spacing: text.isEmpty ? 0 : 6) {
            isChecked ? AnyView(CheckedButton(color: colorToUse ?? .defaultPrimary)) : AnyView(UncheckedButton(color: colorToUse ?? .basic))
            Text(text)
        }
    }
}

private struct CheckedButton: View {
    var color: Color = .pastelBlue
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
        }
    }
}

private struct UncheckedButton: View {
    var color: Color = .basic
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 18, height: 18)
        }
    }
}


struct RadioButton_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            RadioButton(isChecked: true)
            RadioButton(isChecked: false)
            RadioButton(isChecked: true).disabled(true)
            RadioButton(isChecked: false).disabled(true)
            RadioButton(isChecked: false, color: .danger)
            RadioButton(isChecked: false, color: .warning)
            RadioButton(isChecked: false, color: .success)
            RadioButton(isChecked: true, text: "Text")
            RadioButton(isChecked: true, color: .warning, text: "Text and custom color")
        }
    }
}
