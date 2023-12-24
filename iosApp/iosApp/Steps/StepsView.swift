//  StepsView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 4/25/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import Shared
import SDWebImageSwiftUI

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
			ZStack(alignment: CGFloat(geometry.size.width) < CGFloat(geometry.size.height) ? .topLeading : .center) {
				WebImage(url: URL(string: recipe.image))
						.resizable()
						.indicator(.activity)
						.transition(.fade(duration: 0.5))
						.scaledToFill()
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
						.overlay(content: {
							VStack {
								stepsProgressBar()
								instructionStepView()
							}
									.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
									.background(.ultraThinMaterial)
						})
			}
				.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
					.onEnded({ value in
						if value.location.x < geometry.size.width / 2 {
							advanceBy(num: -1)
						} else {
							advanceBy(num: 1)
						}
					})
				)
		}
	}

	@ViewBuilder
	private func stepsProgressBar() -> some View {
		HStack(alignment: .center, spacing: 4) {
			ForEach(self.steps.indices) { x in
				LoadingRectangle(progress: min(max((CGFloat(progress) - CGFloat(x)), 0.0), 1.0))
						.frame(width: nil, height: 2, alignment: .leading)
						.animation(.linear)
			}
		}
				.padding()
	}


	@ViewBuilder
	private func instructionStepView() -> some View {
		InstructionStep(step: steps[Int(self.progress)])
	}


	@ViewBuilder
	private func progressNavigationGestures() -> some View {
		GeometryReader { geometry in
			HStack {
				Spacer()
				Rectangle()
						.foregroundColor(.clear)
						.contentShape(Rectangle())
						.frame(maxWidth: geometry.size.width / 2, minHeight: geometry.size.height)
						.onTapGesture {
							advanceBy(num: -1)
						}

				Rectangle()
						.foregroundColor(.clear)
						.contentShape(Rectangle())
						.frame(maxWidth: geometry.size.width / 2, minHeight: geometry.size.height)
						.onTapGesture {
							advanceBy(num: 1)
						}
				Spacer()
			}
					.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
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
			mainInstructionView()
		}
				.padding()
	}

	@ViewBuilder
	private func mainInstructionView() -> some View {

		LazyVStack(alignment: .leading) {
			Text(step.step)
					.typography(.p1)
					.padding([.bottom])

			if (!step.ingredients.isEmpty) {
				ingredientsListView()
			}

			if (!step.equipment.isEmpty) {
				equipmentsListView()
			}
		}
	}

	@ViewBuilder
	private func ingredientsListView() -> some View {
		Text("Ingredients").typography(.s2)
		ingredientsStack()
	}

	@ViewBuilder
	private func equipmentsListView() -> some View {
		Text("Equipments").typography(.s2)
		equipmentsStack()
	}

	@ViewBuilder
	private func ingredientsStack() -> some View {

		LazyHStack {
			ForEach(step.ingredients, id: \.self.hashValue) { ingredient in
				AsyncImageWithFrame(url: "https://spoonacular.com/cdn/ingredients_100x100/" + ingredient.image)
			}
		}
	}

	@ViewBuilder
	private func equipmentsStack() -> some View {

		LazyHStack {
			ForEach(step.equipment, id: \.self.hashValue) { equipment in
				AsyncImageWithFrame(url: "https://spoonacular.com/cdn/equipment_100x100/" + equipment.image)
			}
		}
	}

	@ViewBuilder
	private func AsyncImageWithFrame(url: String) -> some View {
		AsyncImage(url: URL(string: url)) { imageView in
			imageView
					.resizable()
					.aspectRatio(contentMode: .fit)
					.padding(4)
		} placeholder: {
			ProgressView().foregroundColor(Color.surface)
		}
				.frame(width: 70, height: 70)
				.background(Color.white)
				.clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
				.padding([.trailing])
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
