//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Shared

struct FridgeHeaderCard: View {
    let freshCount: Int
    let expiringSoonCount: Int 
    let expiredCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Fridge icon with liquid glass effect
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "refrigerator.fill")
                            .foregroundStyle(Color.glassHighlight)
                            .font(.title2)
                            .fontWeight(.semibold)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.glassBorder, lineWidth: 0.5)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("My Fresh Fridge")
                        .typography(.h3)
                        .foregroundColor(.white)
                    
                    Text("Natural • Organic • Fresh")
                        .typography(.c1)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
            }
            
            Text("Keep track of your ingredients and their freshness")
                .typography(.p3)
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 16) {
                StatusIndicator(count: freshCount, label: "Fresh", color: .freshPrimary)
                StatusIndicator(count: expiringSoonCount, label: "Expiring Soon", color: .expiringSoonPrimary)
                StatusIndicator(count: expiredCount, label: "Expired", color: .expiredPrimary)
            }
        }
        .padding(20)
            .background(
            // Enhanced liquid glass gradient
            LinearGradient(
                colors: [Color.darkMint, Color.deepGreen.opacity(0.9), Color.forestGreen.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
        .overlay(
            // Glass highlight effect
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [Color.glassHighlight, Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct StatusIndicator: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .shadow(color: color.opacity(0.5), radius: 2, x: 0, y: 1)
            
            Text("\(count) \(label)")
                .typography(.c1)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct LiquidGlassIngredientCard: View {
    let ingredient: Ingredient
    
    // MARK: - Card Dimensions (Full width horizontal layout)
    private let cardHeight: CGFloat = 140
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 120
    private let cornerRadius: CGFloat = 20
    
    // MARK: - Color Mappings
    private var stateColors: (primary: Color, secondary: Color, background: Color) {
        switch ingredient.getExpiryState() {
        case .fresh:
            return (.freshPrimary, .freshSecondary, .freshBackground)
        case .expiringSoon:
            return (.expiringSoonPrimary, .expiringSoonSecondary, .expiringSoonBackground)
        case .expired:
            return (.expiredPrimary, .expiredSecondary, .expiredBackground)
        default:
            return (.freshPrimary, .freshSecondary, .freshBackground)
        }
    }
    
    private var badgeBackgroundColor: Color {
        ingredient.getExpiryState() == .expired ? 
        stateColors.primary : Color.black.opacity(0.75)
    }
    
    // MARK: - Text Formatting Helper
    private var formattedIngredientName: String {
        let name = ingredient.name
        guard !name.isEmpty else { return name }
        return name.prefix(1).uppercased() + name.dropFirst().lowercased()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Left: Image Section with Glass Overlay
            ZStack(alignment: .topTrailing) {
                // Image with glass effect
                WebImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(ingredient.image)"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                
                // Days remaining badge
                Text(ingredient.getDaysRemainingFormatted())
                    .typography(.c2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        badgeBackgroundColor,
                        in: RoundedRectangle(cornerRadius: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.glassHighlight.opacity(0.3), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(8)
            }
            
            // MARK: - Right: Content Section with Horizontal Layout
            VStack(alignment: .leading, spacing: 12) {
                // Top row: Category and Status
                HStack {
                    // Simple category badge (no glass effect)
                    Text(ingredient.getCategory())
                        .typography(.c2)
                        .foregroundColor(stateColors.primary)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(stateColors.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                    
                    // Status text with glass effect
                    Text(ingredient.getStatusText())
                        .typography(.c1)
                        .foregroundColor(stateColors.primary)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .glassEffect(.regular.tint(stateColors.primary.opacity(0.2)), in: RoundedRectangle(cornerRadius: 8))
                }
                
                // Ingredient name (larger, single line)
                Text(formattedIngredientName)
                    .typography(.h6)
                    .foregroundColor(.fontStd)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                // Progress section with enhanced horizontal layout
                VStack(alignment: .leading, spacing: 8) {
                    // Progress bar with glass effect
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track with glass effect
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.glassBorder.opacity(0.2))
                                .frame(height: 10)
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 6))
                            
                            // Progress fill with glass effect
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [stateColors.primary, stateColors.secondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geometry.size.width * max(0.05, min(1, ingredient.expiryProgress())),
                                    height: 10
                                )
                                .glassEffect(.regular.tint(stateColors.primary.opacity(0.3)), in: RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .frame(height: 10)
                    
                    // Days info with glass effects
                    HStack(spacing: 12) {
                        Text("\(ingredient.durationUntilExpiry()) DAYS")
                            .typography(.c1)
                            .foregroundColor(.fontHint)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
                        
                        Text(ingredient.getTotalDaysFormatted())
                            .typography(.c1)
                            .foregroundColor(.fontHint)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 5)
        .shadow(color: stateColors.primary.opacity(0.08), radius: 6, x: 0, y: 3)
        .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Legacy Support (for backward compatibility)
struct EnhancedIngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        LiquidGlassIngredientCard(ingredient: ingredient)
    }
}

struct AddIngredientButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.activePrimary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Add New Ingredient")
                        .typography(.s1)
                        .foregroundColor(.fontStd)
                        .fontWeight(.medium)
                    
                    Text("Scan or search to add")
                        .typography(.c1)
                        .foregroundColor(.fontHint)
                }
                
                Spacer()
                
                Image(systemName: "barcode.viewfinder")
                    .font(.title2)
                    .foregroundStyle(Color.activePrimary.opacity(0.7))
            }
            .padding(16)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StoredIngredient: View {
    let imageUrl: String
    let name: String
    let totalDays: String
    let remaingDays: String
    let progress: Double
    
    var body: some View {
        // Legacy implementation - can be removed after migration
        GeometryReader { geometry in
            let width = geometry.size.width
            
            ZStack {
                VStack(spacing: 0) {
                    WebImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_500x500/\(imageUrl)"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: (width * 1.3) * 0.65)
                        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 12))
                        .background(Color.white)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.pastelBlue,
                                        Color.pastelPink
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
                            .foregroundColor(.pastelBlue)
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
