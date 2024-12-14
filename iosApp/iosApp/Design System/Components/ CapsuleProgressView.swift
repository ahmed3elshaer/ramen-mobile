//
//  CapsuleProgressView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/1/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct CapsuleProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background blur
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
            
            // Progress outline
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0, to: CGFloat(progress / 10))
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.defaultPrimary,
                            Color.defaultPrimary.opacity(0.7),
                            Color.defaultPrimary.opacity(0.5)
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}
