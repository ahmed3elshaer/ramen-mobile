//
//  StepsView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 4/25/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Shared

struct StepsView: View {
	let recipe: Recipe
	let steps: [Recipe.AnalyzedInstructionStep]
	@SwiftUI.State private var progress: Double = 0

	init(recipe: Recipe) {
		self.recipe = recipe
		self.steps = recipe.analyzedInstructions[recipe.analyzedInstructions.startIndex].steps
	}

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .topLeading) {
				AsyncImage(url: URL(string: recipe.image)) { imageView in
					imageView
							.resizable()
							.edgesIgnoringSafeArea(.all)
							.scaledToFill()
							.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)

				} placeholder: {
					ProgressView()
							.foregroundColor(Color.surface)
				}

				VStack {
					HStack(alignment: .center, spacing: 4) {
						ForEach(self.steps.indices) { x in
							LoadingRectangle(progress: min(max((CGFloat(progress) - CGFloat(x)), 0.0), 1.0))
									.frame(width: nil, height: 2, alignment: .leading)
									.animation(.linear)
						}
					}
							.padding()

					InstructionStep(step: steps[Int(self.progress)])
							.frame(width: geometry.size.width, alignment: .center)

				}
						.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
						.background(.thinMaterial)


				HStack(alignment: .center, spacing: 0) {
					Rectangle()
							.foregroundColor(.clear)
							.contentShape(Rectangle())
							.onTapGesture {
								advanceBy(num: -1)
							}
					Rectangle()
							.foregroundColor(.clear)
							.contentShape(Rectangle())
							.onTapGesture {
								advanceBy(num: 1)
							}
				}
			}
		}
	}

	private func advanceBy(num: Int) {
		let newProgress = max((Int(self.progress) + num) % steps.endIndex, 0)
		self.progress = Double(newProgress)
	}

}

struct InstructionStep: View {
	let step: Recipe.AnalyzedInstructionStep
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading) {
				Text(step.step)
						.typography(.p1)
						.padding([.bottom])

				if (!step.ingredients.isEmpty) {
					Text("Ingredients")
							.typography(.s2)

					LazyHStack {
						ForEach(step.ingredients, id: \.self.hashValue) { ingredient in
							AsyncImage(url: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image)) { imageView in
								imageView
										.resizable()
										.aspectRatio(contentMode: .fit)
										.padding(4)

							} placeholder: {
								ProgressView()
										.foregroundColor(Color.surface)
							}
									.frame(width: 70, height: 70)
									.background(Color.white)
									.clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
									.padding([.trailing])
						}
					}
				}
				if (!step.equipment.isEmpty) {
					Text("Equipments")
							.typography(.s2)
					LazyHStack {
						ForEach(step.equipment, id: \.self.hashValue) { equipment in
							AsyncImage(url: URL(string: "https://spoonacular.com/cdn/equipment_100x100/" + equipment.image)) { imageView in
								imageView
										.resizable()
										.aspectRatio(contentMode: .fit)
										.padding(4)

							} placeholder: {
								ProgressView()
										.foregroundColor(Color.surface)
							}
									.frame(width: 70, height: 70)
									.background(Color.white)
									.clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
									.padding([.trailing])
						}
					}
				}
			}
		}
				.padding()
	}
}

struct LoadingRectangle: View {
	var progress: CGFloat

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
						.foregroundColor(Color.white.opacity(0.3))
						.cornerRadius(5)

				Rectangle()
						.frame(width: geometry.size.width * self.progress, height: nil, alignment: .leading)
						.foregroundColor(Color.white.opacity(0.9))
						.cornerRadius(5)

			}
		}
	}
}
