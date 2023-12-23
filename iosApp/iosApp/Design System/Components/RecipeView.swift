//
//  RecipeView.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 12/12/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

import SDWebImageSwiftUI
import Shared

struct RecipeView: View {
	var id: String
	var image: String
	var title: String
	let missingIngredients: [SearchRecipe.Ingredient]

	var body: some View {
		VStack {
			WebImage(url: URL(string: image))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(height: 200)
					.clipped()
					.overlay(createOverlay())
		}
				.cornerRadius(10)
				.padding(.horizontal, 8)
	}

	private func createOverlay() -> some View {
		VStack {
			Spacer()
			Rectangle()
					.frame(height: 50)
					.opacity(0.25)
					.overlay(createInnerOverlay())
					.blurBackground(style: .systemUltraThinMaterial)
		}
	}

	private func createInnerOverlay() -> some View {
		VStack(alignment: .leading) {
			Text(title)
					.font(.headline)
					.fontWeight(.bold)
			createHStackContent()
		}
				.padding()
				.foregroundColor(.white)
	}

	private func createHStackContent() -> some View {
		HStack {
			Text("Missing Items: ")
					.font(.subheadline)
			ForEach(missingIngredients, id: \.self) { item in
				Text(item.name)
						.font(.subheadline)
			}
		}
	}
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension View {
	public func blurBackground(style: UIBlurEffect.Style) -> some View {
		self.background(BlurView(style: style))
	}
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
struct BlurView: UIViewRepresentable {
	var style: UIBlurEffect.Style

	func makeUIView(context: Context) -> some UIView {
		UIView()
	}

	func updateUIView(_ uiView: UIViewType, context: Context) {
		setupBlurViewFor(uiView)
	}

	private func setupBlurViewFor(_ uiView: UIViewType) {
		uiView.backgroundColor = .clear
		let blurEffect = UIBlurEffect(style: style)
		let blurView = UIVisualEffectView(effect: blurEffect)
		uiView.insertSubview(blurView, at: 0)
		blurView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			uiView.topAnchor.constraint(equalTo: blurView.topAnchor),
			uiView.leftAnchor.constraint(equalTo: blurView.leftAnchor),
			uiView.rightAnchor.constraint(equalTo: blurView.rightAnchor),
			uiView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
		])
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		RecipeView(id: "id1",
			image: "https://loremflickr.com/640/480/fashion",
			title: "Sample Title",
			missingIngredients: generateMissingIngredients())
	}

	private static func createIngredient(name: String) -> SearchRecipe.Ingredient {
		return SearchRecipe.Ingredient(
			aisle: "",
			amount: 2.0,
			id: 1,
			image: "",
			name: name,
			original: "",
			originalName: "",
			unit: "",
			unitLong: "",
			unitShort: "")
	}

	private static func generateMissingIngredients() -> [SearchRecipe.Ingredient] {
		return ["Item 1", "Item 2", "Item 3"].map {
			createIngredient(name: $0)
		}
	}
}
