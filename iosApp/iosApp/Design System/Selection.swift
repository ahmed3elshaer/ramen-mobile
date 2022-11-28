//
//  Selection.swift
//  BricksUI
//
//  Created by Carlos Bystron on 04.05.20.
//  Copyright © 2020 Fabio Staiano. All rights reserved.
//

import Foundation
import SwiftUI

struct selection: View {
    
    enum Style {
        case defaultStyle,
             disabled,
             success,
             warning,
             danger,
             info
    }
    
    var style: Style = .defaultStyle
    var placeholder: String
    var icon: Image? = nil
    var commit: ()->() = { }
    @State private var focused: Bool = false
    @State var input: String = ""
    
    // MARK:  Function declarations
    
    fileprivate func defaultStyle() -> some View {
        HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                TextField("", text: $input, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        print("TextField focused")
                        self.focused = true
                    } else {
                        print("TextField focus removed")
                        self.focused = false
                    }
                }, onCommit: commit).foregroundColor(Color.fontStd)
            }
            if focused { icon.imageScale(.large).foregroundColor(Color.defaultPrimary) }
            else { icon.imageScale(.large).foregroundColor(Color.basic) }
        }
         .padding()
         .background(RoundedRectangle(cornerRadius: 5).foregroundColor(self.focused ? Color.basic.opacity(0) : Color.basic.opacity(0.1)))
         .overlay(RoundedRectangle(cornerRadius: 5).stroke(self.focused ? Color.defaultPrimary : Color.basic.opacity(0.4), lineWidth: 1))
    }
    
    fileprivate func success() -> some View {
         HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                TextField("", text: $input, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        print("TextField focused")
                        self.focused = true
                    } else {
                        print("TextField focus removed")
                        self.focused = false
                    }
                }, onCommit: commit).foregroundColor(Color.fontStd)
            }
            icon.imageScale(.large).foregroundColor(Color.success)
         }
         .padding()
         .background(RoundedRectangle(cornerRadius: 5).foregroundColor(self.focused ? Color.basic.opacity(0) : Color.basic.opacity(0.1)))
         .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.success, lineWidth: 1))
    }
    
    fileprivate func warning() -> some View {
         HStack {
            ZStack(alignment: .leading) {
                if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                TextField("", text: $input, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        print("TextField focused")
                        self.focused = true
                    } else {
                        print("TextField focus removed")
                        self.focused = false
                    }
                }, onCommit: commit).foregroundColor(Color.fontStd)
            }
            icon.imageScale(.large).foregroundColor(Color.warning)
         }
         .padding()
         .background(RoundedRectangle(cornerRadius: 5).foregroundColor(self.focused ? Color.basic.opacity(0) : Color.basic.opacity(0.1)))
         .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.warning, lineWidth: 1))
    }
    
    fileprivate func danger() -> some View {
            HStack {
               ZStack(alignment: .leading) {
                   if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                   TextField("", text: $input, onEditingChanged: { (editingChanged) in
                       if editingChanged {
                           print("TextField focused")
                           self.focused = true
                       } else {
                           print("TextField focus removed")
                           self.focused = false
                       }
                   }, onCommit: commit).foregroundColor(Color.fontStd)
               }
               icon.imageScale(.large).foregroundColor(Color.danger)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(self.focused ? Color.basic.opacity(0) : Color.basic.opacity(0.1)))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.danger, lineWidth: 1))
    }
    
    fileprivate func info() -> some View {
            HStack {
               ZStack(alignment: .leading) {
                   if input.isEmpty { Text(placeholder).foregroundColor(Color.basic) }
                   TextField("", text: $input, onEditingChanged: { (editingChanged) in
                       if editingChanged {
                           print("TextField focused")
                           self.focused = true
                       } else {
                           print("TextField focus removed")
                           self.focused = false
                       }
                   }, onCommit: commit).foregroundColor(Color.fontStd)
               }
               icon.imageScale(.large).foregroundColor(Color.info)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(self.focused ? Color.basic.opacity(0) : Color.basic.opacity(0.1)))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.info, lineWidth: 1))
    }
    
    // MARK:  Body
    
    var body: some View {
        
        switch style {
        case .success:
            return AnyView(success())
        case .warning:
                   return AnyView(warning())
        case .danger:
                   return AnyView(danger())
        case .info:
                   return AnyView(info())
        default:
            return AnyView(defaultStyle())
        }
    }
}

// MARK: Preview

struct Selection_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(spacing: 20) {
            ThemeTextField("Test")
            ThemeTextField("Thats a default Textfield", onCommit: {print("party")})
            ThemeTextField("Thats a default Textfield + Icon", icon: Image(systemName: "star.fill"), onCommit: {print("party")})
            ThemeTextField("Success", style: .success, icon: Image(systemName: "star.fill"))
            ThemeTextField("Warning", style: .warning, icon: Image(systemName: "star.fill"))
            ThemeTextField("Danger", style: .danger, icon: Image(systemName: "star.fill"))
            ThemeTextField("Info", style: .info, icon: Image(systemName: "star.fill"))
        }
        .padding()
    }
}
