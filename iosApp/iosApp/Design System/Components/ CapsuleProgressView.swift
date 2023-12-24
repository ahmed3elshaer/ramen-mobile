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
	let image: String

	var body: some View {
		ZStack {
			Capsule()
					.fill(Color.clear)
					.frame(width: 120, height: 120)
					.overlay(
						WebImage(url: URL(string: image))
								.resizable()
                                .aspectRatio(contentMode: .fit)
								.clipShape(Circle())
                                .padding(10)
                                .overlay(
                                    Circle()
                                            .trim(from: 0, to: CGFloat(progress / 10))
                                            .stroke(LinearGradient(
                                                colors: [Color.defaultPrimary,
                                                         Color.defaultPrimary.opacity(0.5)],
                                                startPoint: .leading,
                                                endPoint: .trailing),
                                                style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                            .rotationEffect(.degrees(-90))
                                            .animation(.linear)
                                            ,
                                    alignment: .center
                                ),
						alignment: .center
					)

		}
	}
}

struct CapsuleProgressView_Preview: PreviewProvider {
	static var previews: some View {
		CapsuleProgressView(progress: 1.0, image: "https://loremflickr.com/640/480/technics")
	}
}
