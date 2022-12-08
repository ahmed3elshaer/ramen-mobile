//
//  CircularProgressView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/1/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct  CapsuleProgressView{
    let progress: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    Color.activePrimary.opacity(0.2),
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .trim(from: 0, to: progress)
                .stroke(
                    Color.activePrimary.opacity(0.6),
                    style: StrokeStyle(
                        lineWidth: 7,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)


        }
    }
}

 
