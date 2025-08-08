//
//  RecipeDetail.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 3/14/23.
//  Copyright 2023 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct RecipeDetail: View {
	let recipeId: String
	@SwiftUI.State private var selection: String? = nil

	@StateObject var store: RecipeDetailsStoreWrapper = RecipeDetailsStoreWrapper()
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		let recipe = store.state.recipe
		ZStack {
			// Dark green gradient background
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark ? [
                    Color.black.opacity(0.8),
                    Color.darkMint.opacity(0.4),
                    Color.forestGreen.opacity(0.3),
                    Color.black.opacity(0.9)
                ] : [
                    Color.black.opacity(0.6),
                    Color.darkMint.opacity(0.3),
                    Color.forestGreen.opacity(0.2),
                    Color.black.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
			
			ScrollView {
				VStack(spacing: 8) {
					// Hero Section with Overlay
					HeroSection(recipe: recipe)
						.padding(.horizontal, 12)
					// Ingredients Panel
					IngredientsPanel(recipe: recipe)
						.padding(.horizontal, 12)
					
					// Nutrition Panel
					NutritionPanel(recipe: recipe)
						.padding(.horizontal, 12)
					
					// Instructions Panel
					InstructionsPanel(recipe: recipe)
						.padding(.horizontal, 12)
					
					// About This Recipe Panel
					AboutRecipePanel(recipe: recipe)
						.padding(.horizontal, 12)
					
					Spacer(minLength: 60)
				}
				.padding(.top, 6)
			}
			
			// Floating Start Cooking Button
			if !recipe.analyzedInstructions.isEmpty {
				VStack {
					Spacer()
					HStack {
						Spacer()
						NavigationLink(destination: RecipeStepView(recipe: recipe), tag: recipe.id.description, selection: $selection) {
							Button {
								selection = recipe.id.description
							} label: {
								HStack(spacing: 6) {
									Image(systemName: "flame.fill")
										.font(.subheadline)
									Text("Start Cooking")
										.font(.subheadline)
										.fontWeight(.semibold)
								}
								.padding(.horizontal, 12)
								.padding(.vertical, 8)
                                .glassEffect()
							}
						}
						.padding(12)
					}
				}
			}
		}
		.onAppear {
			store.dispatch(RecipeInfoAction.GetRecipeInfo(id: recipeId))
		}
	}
	
	private func getDifficultyLevel(for recipe: Recipe) -> String {
		let stepCount = recipe.analyzedInstructions.first?.steps.count ?? 0
		let totalTime = recipe.readyInMinutes
		
		if stepCount <= 3 && totalTime <= 30 {
			return "Easy"
		} else if stepCount <= 8 && totalTime <= 60 {
			return "Medium"
		} else {
			return "Hard"
		}
	}
}

// MARK: - Hero Section
private struct HeroSection: View {
	let recipe: Recipe
	
	// Mock ingredient availability
	private var availabilityPercentage: Int { 0 } // In real app, calculate from user's pantry
	
	var body: some View {
		ZStack {
			// Background image
			AsyncImage(url: URL(string: recipe.image)) { imageView in
				imageView
					.resizable()
					.aspectRatio(contentMode: .fill)
			} placeholder: {
				RoundedRectangle(cornerRadius: 20)
					.fill(Color.gray.opacity(0.3))
			}
			.frame(height: 180)
			.clipped()
			
			// Dark overlay for text readability
			Rectangle()
				.fill(
					LinearGradient(
						gradient: Gradient(colors: [
							Color.black.opacity(0.1),
							Color.black.opacity(0.6)
						]),
						startPoint: .top,
						endPoint: .bottom
					)
				)
			
			VStack {
				// Top chips
				HStack {
					Spacer()
					
					HStack(spacing: 6) {
						// Availability chip
						HStack(spacing: 4) {
							Text("\(availabilityPercentage)% Available")
								.font(.caption)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(Color.teal.opacity(0.8))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						
						// Likes chip
						HStack(spacing: 4) {
							Image(systemName: "heart.fill")
								.font(.caption)
							Text("\(recipe.aggregateLikes)")
								.font(.caption)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						.padding(.horizontal, 8)
						.padding(.vertical, 4)
						.background(Color.red.opacity(0.7))
						.clipShape(RoundedRectangle(cornerRadius: 10))
					}
				}
				.padding(.top, 12)
				.padding(.horizontal, 12)
				
				Spacer()
				
				// Bottom content
				VStack(alignment: .leading, spacing: 10) {
					// Title
					Text(recipe.title)
						.font(.title2)
						.fontWeight(.bold)
						.foregroundColor(.white)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					// Stats row
					HStack(spacing: 12) {
						// Time
						HStack(spacing: 4) {
							Image(systemName: "clock")
								.font(.caption)
							Text("\(recipe.readyInMinutes)m")
								.font(.caption)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						
						// Servings
						HStack(spacing: 4) {
							Image(systemName: "person.2")
								.font(.caption)
							Text("\(recipe.servings) servings")
								.font(.caption)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						
						// Calories (mock data)
						HStack(spacing: 4) {
							Image(systemName: "bolt.fill")
								.font(.caption)
							Text("155 cal")
								.font(.caption)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						
						Spacer()
					}
					
					// Health score
					HStack(spacing: 4) {
						Image(systemName: "star.fill")
							.font(.caption)
							.foregroundColor(.yellow)
						Text("\(Int(recipe.healthScore))/100")
							.font(.caption)
							.fontWeight(.medium)
							.foregroundColor(.white)
					}
				}
				.padding(12)
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
}

// MARK: - Info Card
private struct InfoCard: View {
	let icon: String
	let iconColor: Color
	let title: String
	let value: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Image(systemName: icon)
					.font(.title3)
					.foregroundColor(iconColor)
				Spacer()
			}
			
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.caption)
					.foregroundColor(.white.opacity(0.7))
				Text(value)
					.font(.subheadline)
					.fontWeight(.bold)
					.foregroundColor(.white)
			}
		}
		.padding(10)
		.frame(maxWidth: .infinity,minHeight: 100,alignment: .leading)
		.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

// MARK: - Dietary Information Card
private struct DietaryInfoCard: View {
	let recipe: Recipe
	
	private var primaryBadges: [String] {
		var badges: [String] = []
		if recipe.glutenFree { badges.append("Gluten Free") }
		if recipe.vegan { badges.append("Vegan") }
		if recipe.vegetarian { badges.append("Vegetarian") }
		return badges
	}
	
	private var secondaryTags: [String] {
		var tags: [String] = []
		if recipe.dairyFree { tags.append("dairy free") }
		if recipe.veryHealthy { tags.append("healthy") }
		if recipe.lowFodmap { tags.append("low fodmap") }
		// Add diets from the recipe
		tags.append(contentsOf: recipe.diets.map { $0.lowercased() })
		return Array(Set(tags)).prefix(3).map { String($0) } // Remove duplicates and limit
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "leaf.fill")
					.font(.title3)
					.foregroundColor(.green)
				Text("Dietary Information")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
				Spacer()
			}
			
			// Primary badges (larger, orange/yellow)
			if !primaryBadges.isEmpty {
				HStack(spacing: 6) {
					ForEach(primaryBadges, id: \.self) { badge in
						Text(badge)
							.font(.caption)
							.fontWeight(.medium)
							.foregroundColor(.black)
							.padding(.horizontal, 10)
							.padding(.vertical, 4)
							.background(Color.orange)
							.clipShape(RoundedRectangle(cornerRadius: 12))
					}
				}
			}
			
			// Secondary tags (smaller, teal)
			if !secondaryTags.isEmpty {
				HStack(spacing: 4) {
					ForEach(secondaryTags, id: \.self) { tag in
						Text(tag)
							.font(.caption2)
							.fontWeight(.medium)
							.foregroundColor(.white)
							.padding(.horizontal, 6)
							.padding(.vertical, 3)
							.background(Color.teal)
							.clipShape(RoundedRectangle(cornerRadius: 8))
					}
				}
			}
		}
		.padding(10)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color(red: 0.2, green: 0.35, blue: 0.3).opacity(0.8))
		.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}

// MARK: - Ingredients Panel
private struct IngredientsPanel: View {
	let recipe: Recipe
	
	// Mock ingredient availability - in real app this would come from user's pantry
	private var availableCount: Int { 0 }
	private var missingCount: Int { recipe.extendedIngredients.count }
	private var availabilityProgress: Double { 
		guard recipe.extendedIngredients.count > 0 else { return 0 }
		return Double(availableCount) / Double(recipe.extendedIngredients.count)
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "basket.fill")
					.font(.title3)
					.foregroundColor(.orange)
				Text("Ingredients (\(recipe.extendedIngredients.count))")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
				
				Spacer()
				
				VStack(alignment: .trailing, spacing: 2) {
					Text("\(availableCount) available")
						.font(.caption)
						.foregroundColor(.green)
					Text("\(missingCount) missing")
						.font(.caption)
						.foregroundColor(.red)
				}
			}
			
			// Progress bar
			ProgressView(value: availabilityProgress)
				.progressViewStyle(LinearProgressViewStyle(tint: .green))
				.scaleEffect(x: 1, y: 2, anchor: .center)
			
			// Ingredients list
			ForEach(recipe.extendedIngredients.prefix(10), id: \.id) { ingredient in
				VStack(spacing: 0) {
					HStack(spacing: 10) {
						// Ingredient image
						AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image)) { imageView in
							imageView
								.resizable()
								.aspectRatio(contentMode: .fit)
						} placeholder: {
							RoundedRectangle(cornerRadius: 8)
								.fill(Color.gray.opacity(0.3))
								.overlay(
									Image(systemName: "photo")
										.foregroundColor(.gray)
								)
						}
						.frame(width: 36, height: 36)
						.clipShape(RoundedRectangle(cornerRadius: 8))
						
						VStack(alignment: .leading, spacing: 2) {
							Text(ingredient.name.capitalized)
								.font(.subheadline)
								.fontWeight(.medium)
								.foregroundColor(.white)
							
							if !ingredient.aisle.isEmpty {
								Text(ingredient.aisle)
									.font(.caption)
									.foregroundColor(.gray)
							}
						}
						
						Spacer()
						
						VStack(alignment: .trailing, spacing: 2) {
							Text("\(String(format: "%.0f", ingredient.measures.metric.amount)) \(ingredient.measures.metric.unitShort)")
								.font(.subheadline)
								.fontWeight(.medium)
								.foregroundColor(.white)
						}
					}
					.padding(.vertical, 6)
					
					// Bottom border indicator (red for missing, green for available)
					Rectangle()
						.fill(Color.red) // In real app, this would be green if available
						.frame(height: 1)
						.opacity(0.6)
				}
			}
		}
		.padding(12)
        .glassEffect(.regular, in:  RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

// MARK: - Nutrition Panel
private struct NutritionPanel: View {
	let recipe: Recipe
	
	// Mock nutrition data - in real app this might come from a nutrition API or be part of the recipe model
	private var mockCalories: Int { 155 }
	private var mockProtein: Int { 5 }
	private var mockFat: Int { 14 }
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "heart.fill")
					.font(.title3)
					.foregroundColor(.red)
				Text("Nutrition (per serving)")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
			}
			
			HStack(spacing: 18) {
				// Calories
				NutritionStat(
					icon: "bolt.fill",
					iconColor: .orange,
					value: "\(mockCalories)",
					label: "Calories"
				)
				
				// Protein
				NutritionStat(
					icon: "circle.fill",
					iconColor: .blue,
					value: "\(mockProtein)g",
					label: "Protein"
				)
				
				// Fat
				NutritionStat(
					icon: "fork.knife",
					iconColor: .yellow,
					value: "\(mockFat)g",
					label: "Fat"
				)
			}
		}
		.padding(12)
        .glassEffect(.regular, in:  RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

private struct NutritionStat: View {
	let icon: String
	let iconColor: Color
	let value: String
	let label: String
	
	var body: some View {
		VStack(spacing: 6) {
			Image(systemName: icon)
				.font(.title2)
				.foregroundColor(iconColor)
				.frame(width: 36, height: 36)
				.background(iconColor.opacity(0.2))
				.clipShape(Circle())
			
			Text(value)
				.font(.title3)
				.fontWeight(.bold)
				.foregroundColor(.white)
			
			Text(label)
				.font(.caption)
				.foregroundColor(.gray)
		}
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Instructions Panel
private struct InstructionsPanel: View {
	let recipe: Recipe
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack {
				Image(systemName: "list.bullet")
					.font(.title3)
					.foregroundColor(.blue)
				Text("Instructions")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
			}
			
			if let firstInstruction = recipe.analyzedInstructions.first {
				ForEach(Array(firstInstruction.steps.prefix(3).enumerated()), id: \.offset) { index, step in
                    InstructionStep(stepNumber: Int(step.number), stepText: step.step, equipment: step.equipment)
				}
				
				if firstInstruction.steps.count > 3 {
					Text("+ \(firstInstruction.steps.count - 3) more steps...")
						.font(.caption)
						.foregroundColor(.gray)
						.padding(.top, 4)
				}
			}
		}
		.padding(12)
        .glassEffect(.regular, in:  RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

private struct InstructionStep: View {
	let stepNumber: Int
	let stepText: String
	let equipment: [Recipe.AnalyzedInstructionStepEquipment]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack(alignment: .top, spacing: 10) {
				// Step number
				Text("\(stepNumber)")
					.font(.subheadline)
					.fontWeight(.bold)
					.foregroundColor(.white)
					.frame(width: 20, height: 20)
					.background(Color.teal)
					.clipShape(Circle())
				
				// Step text
				Text(stepText)
					.font(.subheadline)
					.foregroundColor(.white)
					.lineLimit(3)
			}
			
			// Equipment tags
			if !equipment.isEmpty {
				HStack(spacing: 4) {
					ForEach(equipment.prefix(2), id: \.id) { item in
						Text(item.name)
							.font(.caption)
							.foregroundColor(.white)
							.padding(.horizontal, 6)
							.padding(.vertical, 3)
							.background(Color.teal)
							.clipShape(RoundedRectangle(cornerRadius: 8))
					}
				}
			}
		}
		.padding(.vertical, 6)
	}
}

// MARK: - About This Recipe Panel
private struct AboutRecipePanel: View {
	let recipe: Recipe
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack {
				Image(systemName: "info.circle.fill")
					.font(.title3)
					.foregroundColor(.blue)
				Text("About this recipe")
					.font(.subheadline)
					.fontWeight(.semibold)
					.foregroundColor(.white)
			}
			
			// Description/Summary
			if !recipe.summary.isEmpty {
				VStack(alignment: .leading, spacing: 6) {
					Text("Description")
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundColor(.white.opacity(0.9))
					
					Text(recipe.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
						.font(.body)
						.foregroundColor(.white.opacity(0.8))
						.lineLimit(10)
				}
			}
			
			// Recipe details
			VStack(alignment: .leading, spacing: 10) {
				if recipe.preparationMinutes > 0 {
					DetailRow(label: "Preparation time", value: "\(recipe.preparationMinutes) minutes")
				}
				
				if recipe.cookingMinutes > 0 {
					DetailRow(label: "Cooking time", value: "\(recipe.cookingMinutes) minutes")
				}
				
				if recipe.weightWatcherSmartPoints > 0 {
					DetailRow(label: "Weight Watchers Points", value: "\(recipe.weightWatcherSmartPoints)")
				}
			}
			
			// Source and links
			VStack(alignment: .leading, spacing: 6) {
				if !recipe.sourceName.isEmpty {
					DetailRow(label: "Source", value: recipe.sourceName)
				}
				
				if !recipe.creditsText.isEmpty {
					DetailRow(label: "Credits", value: recipe.creditsText)
				}
				
				// External links
				if !recipe.sourceUrl.isEmpty {
					Button(action: {
						if let url = URL(string: recipe.sourceUrl) {
							UIApplication.shared.open(url)
						}
					}) {
						HStack {
							Image(systemName: "link")
							Text("View Original Recipe")
							Spacer()
							Image(systemName: "arrow.up.right")
						}
						.foregroundColor(.teal)
						.padding(10)
						.background(Color.teal.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 8))
					}
				}
				
				if !recipe.spoonacularSourceUrl.isEmpty {
					Button(action: {
						if let url = URL(string: recipe.spoonacularSourceUrl) {
							UIApplication.shared.open(url)
						}
					}) {
						HStack {
							Image(systemName: "link")
							Text("View on Spoonacular")
							Spacer()
							Image(systemName: "arrow.up.right")
						}
						.foregroundColor(.teal)
						.padding(10)
						.background(Color.teal.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 8))
					}
				}
			}
			
			// Wine pairing
			if !recipe.winePairing.pairingText.isEmpty {
				VStack(alignment: .leading, spacing: 6) {
					Text("Wine Pairing")
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundColor(.white.opacity(0.9))
					
					Text(recipe.winePairing.pairingText)
						.font(.body)
						.foregroundColor(.white.opacity(0.8))
				}
			}
		}
		.padding(12)
        .glassEffect(.regular, in:  RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
	}
}

private struct DetailRow: View {
	let label: String
	let value: String
	
	var body: some View {
		HStack {
			Text(label)
				.font(.subheadline)
				.foregroundColor(.white.opacity(0.7))
			Spacer()
			Text(value)
				.font(.subheadline)
				.fontWeight(.medium)
				.foregroundColor(.white)
		}
	}
}
