//
//  LiquidGlassRoundedFloating.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 26/07/2025.
//  Copyright © 2025 orgName. All rights reserved.
//


//
//  LiquidGlassRoundedFloating.swift
//  SwiftUIiOS26
//
//  Liquid Glass: Intersection with surfaces
//

import SwiftUI

struct LiquidGlassRoundedFloating: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.bricksLogo)
                    .resizable()
                    .ignoresSafeArea(edges: .all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        HStack {
                            Image(systemName: "trash")
                            Spacer()
                            Image(systemName: "folder")
                            Spacer()
                            Image(systemName: "arrowshape.turn.up.left")
                        }
                        .zIndex(1)
                        .padding(16)
                        .font(.largeTitle)
                        .glassEffect()
                       
                        Button {
                            //
                        } label: {
                            Image(systemName: "bubble.and.pencil")
                                .padding(8)
                                .font(.title)
                        }
                        .phaseAnimator([false, true]) { bgImage, move in
                            bgImage
                                .offset(x: move ? -84 : 0)
                        } animation: { move in
                                .easeInOut(duration: 6)
                        }
                       
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    LiquidGlassRoundedFloating()
}
