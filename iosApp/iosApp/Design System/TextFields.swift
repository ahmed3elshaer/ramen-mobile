//
//  TextField.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI
import WebKit

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
            if focused { icon.imageScale(.large).foregroundColor(.pastelBlue) }
            else { icon.imageScale(.large).foregroundColor(.basic) }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
        .stroke(self.focused ? Color.pastelBlue : Color.basic.opacity(0.4), lineWidth: 1))
    }
    
    fileprivate func primary() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(.pastelBlue) }
                TextField("", text: $input, onEditingChanged: { editingChanged in
                    self.focused = editingChanged
                    print(editingChanged ? "TextField focused" : "TextField focus removed")
                }, onCommit: commit).foregroundColor(.fontStd)
            }
             icon.imageScale(.large).foregroundColor(.pastelBlue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
        .stroke(Color.pastelBlue, lineWidth: 1))
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
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
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
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
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
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
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
        .background(RoundedRectangle(cornerRadius: 45)
        .foregroundColor(Color.basic.opacity(self.focused ? 0 : 0.1)))
        .overlay(RoundedRectangle(cornerRadius: 45)
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

extension TextField {
    func outlinedStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .frame(height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 54)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(8)
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



@available(iOS 15, *)
struct HtmlText: UIViewRepresentable {
    let html : String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
      }
       
      func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
      }
}
