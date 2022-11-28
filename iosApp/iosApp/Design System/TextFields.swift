//
//  TextField.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

public struct ThemeTextField: View {
    
    enum Style {
        case defaultStyle, primary, disabled, success, warning, danger, info
    }
    
    var style: Style
    var placeholder: String
    var icon: Image? = nil
    var commit: ()->() = { }
    @State private var focused: Bool = false
    @State var input: String = ""
    
    // MARK: Inits
    
    init(_ placeholder: String, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        self.style = .defaultStyle
        self.commit = onCommit
    }
    
    init(_ placeholder: String, style: Style, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        self.style = style
        self.commit = onCommit
    }
    
    init(_ placeholder: String, icon: Image, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        self.icon = icon
        self.style = .defaultStyle
        self.commit = onCommit
    }
    
    init(_ placeholder: String, style: Style, icon: Image, onCommit: @escaping ()->() = { }) {
        self.placeholder = placeholder
        self.style = style
        self.icon = icon
        self.commit = onCommit
    }
    
    // MARK:  Function declarations
    
    fileprivate func defaultStyle() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.basic) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
            if focused { icon.imageScale(.large).foregroundColor(.defaultPrimary) }
            else { icon.imageScale(.large).foregroundColor(.basic) }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(self.focused ? Color.defaultPrimary : Color.basic.opacity(0.4), lineWidth: 1))
    }
    
    fileprivate func primary() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.defaultPrimary) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
             icon.imageScale(.large).foregroundColor(.defaultPrimary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.defaultPrimary, lineWidth: 1))
    }
    
    fileprivate func success() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.basic) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
            icon.imageScale(.large).foregroundColor(.success)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.success, lineWidth: 1))
    }
    
    fileprivate func warning() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
            icon.imageScale(.large).foregroundColor(.warning)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.warning, lineWidth: 1))
    }
    
    fileprivate func danger() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.basic) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
            icon.imageScale(.large).foregroundColor(.danger)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.danger, lineWidth: 1))
    }
    
    fileprivate func info() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.basic) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
            icon.imageScale(.large).foregroundColor(.info)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 5)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 5)
        .stroke(Color.info, lineWidth: 1))
    }
    
    // MARK:  Body
    
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
}

// MARK: Preview

struct TextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ThemeTextField("Thats a default Textfield", onCommit: {print("party")})
            ThemeTextField("Thats a default Textfield + Icon", icon: Image(systemName: "star.fill"), onCommit: {print("party")})
            ThemeTextField("Primary", style: .primary, icon: Image(systemName: "star.fill"))
            ThemeTextField("Success", style: .success, icon: Image(systemName: "star.fill"))
            ThemeTextField("Warning", style: .warning, icon: Image(systemName: "star.fill"))
            ThemeTextField("Danger", style: .danger, icon: Image(systemName: "star.fill"))
            ThemeTextField("Info", style: .info, icon: Image(systemName: "star.fill"))
        }
        .padding()
    }
}
