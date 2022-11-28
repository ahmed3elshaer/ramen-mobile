//
//  Typography.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

public struct Typography: ViewModifier {
    
    enum Style {
        
        /// Titles
        case h1, h2, h3, h4, h5, h6
        
        /// Subtitles
        case s1, s2
        
        /// Paragraphs
        case p1, p2
        
        /// Captions
        case c1, c2
    }
    
    var style: Style
    
    public func body(content: Content) -> some View {
        switch style {
        case .h1: return content
            .font(.system(size: 36, weight: .bold))
        case .h2: return content
            .font(.system(size: 32, weight: .bold))
        case .h3: return content
            .font(.system(size: 30, weight: .bold))
        case .h4: return content
            .font(.system(size: 26, weight: .bold))
        case .h5: return content
            .font(.system(size: 22, weight: .bold))
        case .h6: return content
            .font(.system(size: 18, weight: .bold))
            
        case .s1: return content
            .font(.system(size: 15, weight: .semibold))
        case .s2: return content
            .font(.system(size: 13, weight: .semibold))
            
        case .p1: return content
            .font(.system(size: 15, weight: .regular))
        case .p2: return content
            .font(.system(size: 13, weight: .regular))
            
        case .c1: return content
            .font(.system(size: 12, weight: .regular))
        case .c2: return content
            .font(.system(size: 12, weight: .bold))
        }
    }
}

extension View {
    func typography(_ style: Typography.Style) -> some View {
        self
            .modifier(Typography(style: style))
    }
    
    func typography(_ style: Typography.Style, color: Color) -> some View {
        self
            .modifier(Typography(style: style))
            .foregroundColor(color)
    }
}


struct Typography_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            Group {
                Text("Typography h1").typography(.h1, color: .defaultPrimary)
                Text("Typography h1").typography(.h1, color: .success)
                Text("Typography h1").typography(.h1, color: .danger)
            
                Text("Typography h1").typography(.h1)
                Text("Typography h2").typography(.h2)
                Text("Typography h3").typography(.h3)
                Text("Typography h4").typography(.h4)
                Text("Typography h5").typography(.h5)
                Text("Typography h6").typography(.h6)
            }
            Group {
                Text("Typography h1").typography(.s1)
                Text("Typography h2").typography(.s2)
                
                Text("Typography p1").typography(.p1)
                Text("Typography p2").typography(.p2)
                
                Text("Typography c1").typography(.c1)
                Text("Typography c2").typography(.c2)
            }
        }
    }
}
