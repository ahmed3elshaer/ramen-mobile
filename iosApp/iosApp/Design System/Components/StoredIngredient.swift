//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct NoisePattern: View {
    var body: some View {
        Color.white.opacity(0.1)
            .background(
                Image(uiImage: generateNoiseImage())
                    .resizable()
                    .blendMode(.overlay)
            )
    }
    
    private func generateNoiseImage() -> UIImage {
        let size = CGSize(width: 300, height: 300)
        let context = CIContext()
        
        // Create noise filter
        guard let noiseFilter = CIFilter(name: "CIRandomGenerator") else {
            return UIImage()
        }
        
        // Create colored noise
        guard let outputImage = noiseFilter.outputImage?.cropped(to: CGRect(origin: .zero, size: size)) else {
            return UIImage()
        }
        
        // Adjust noise intensity
        let finalFilter = CIFilter(name: "CIColorControls")
        finalFilter?.setValue(outputImage, forKey: kCIInputImageKey)
        finalFilter?.setValue(0.1, forKey: kCIInputContrastKey) // Adjust for desired noise intensity
        
        guard let finalOutput = finalFilter?.outputImage,
              let cgImage = context.createCGImage(finalOutput, from: finalOutput.extent) else {
            return UIImage()
        }
        
        return UIImage(cgImage: cgImage)
    }
}

struct StoredIngredient: View {
    let imageUrl: String
    let name: String
    let totalDays: String
    let remaingDays: String
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                // Progress ring as border
                VStack(spacing: 0) {
                    // Image takes up 2/3 of height
                    WebImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(imageUrl)"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: (width * 1.3) * 0.65)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12))
                        .background(Color.white)
                    
                    ZStack(alignment: .leading) {
                        // Background track
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        // Progress fill
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.accentColor,
                                        Color.activePrimary
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: width * progress, height: 4)
                    }
                    
                    VStack(spacing: 4) {
                        Text(name)
                            .typography(.s1)
                            .foregroundColor(.activePrimary)
                            .lineLimit(1)
                        
                        Text("\(remaingDays) of \(totalDays) days")
                            .typography(.s2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 12)
                }
            }
        }
        .aspectRatio(3/4, contentMode: .fit)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
