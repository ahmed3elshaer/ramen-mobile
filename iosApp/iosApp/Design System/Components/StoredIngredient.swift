//
//  StoredIngredientCard.swift
//  iosApp
//
//  Created by Ahmed Elshaer on 11/29/22.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct StoredIngredient: View {
	let imageUrl: String
	let name: String
	let totalDays: String
	let remaingDays: String
	let progress: Double


	init(imageUrl: String,
		 name: String,
		 totalDays: String,
		 remaingDays: String,
		 progress: Double) {
		self.imageUrl = imageUrl
		self.name = name
		self.totalDays = totalDays
		self.remaingDays = remaingDays
		self.progress = progress
	}

	var body: some View {
		VStack(alignment: .center) {
			CapsuleProgressView(progress: progress * 10, image: "https://spoonacular.com/cdn/ingredients_100x100/\(imageUrl)")
			Text(name)
					.typography(.p2)
					.lineLimit(2)
			Text("\(remaingDays.description) of \(totalDays) days")
					.typography(.s2)
		}
	}

}

struct StoredIngredientCard_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			StoredIngredient(imageUrl: "https://loremflickr.com/640/480",
				name: "Durgan",
				totalDays: "7",
				remaingDays: "3",
				progress: 1)
			StoredIngredient(imageUrl: "https://loremflickr.com/640/480/food",
				name: "Mosciski",
				totalDays: "20",
				remaingDays: "10",
				progress: 0.25)
		}
	}

}


