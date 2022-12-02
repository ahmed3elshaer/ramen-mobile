//
//  CircularProgressView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/1/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.defaultPrimary.opacity(0.5),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.activePrimary,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)

        }
    }
}

 struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.25)
            .frame(width: 64, height: 64)
    }
}
