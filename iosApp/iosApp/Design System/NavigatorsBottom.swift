//
//  NavigatorsBottom.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

struct NavigatorBottom : View {
    
    @State var index : Int
    var icons: [String]
    //var text : [String]? = [""]
    
    var body : some View {
        
        GeometryReader { g in
            HStack(spacing: 0) {
                return self.makeTabs(totalWidth: g.size.width)
            }
        }.frame(height: 76)
            .background(Color.background)
    }
    
    func makeTabs(totalWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<icons.count) { i in
                Button(action: {self.index = i}, label: {
                    VStack {
                        Image(systemName: self.icons[i])
                            .square(width: self.index == i ? 24 : 21)
                            .foregroundColor(self.index == i ? Color.defaultPrimary : Color.fontDisabled)
                            .padding(.bottom, 24)
                            .padding(.top, 10)
                    }
                    .frame(width: totalWidth / CGFloat(self.icons.count))
                    .animation(.easeOut(duration: 0.35))
                })
                .background(Color.background)
                .background(VisualEffect(style: .systemThinMaterial))
            }
        }
    }
}


struct BRNavigatorBottom_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack {Color.defaultPrimary.opacity(0.4)}
            
            NavigatorBottom(index: 0, icons: ["house.fill", "magnifyingglass", "heart.fill", "person.fill"])
        }
        .edgesIgnoringSafeArea(.all)
    }
}
