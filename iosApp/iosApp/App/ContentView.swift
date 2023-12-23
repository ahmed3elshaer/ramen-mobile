import SwiftUI
import Shared


/// `HomeScreen` is a `View` in the SwiftUI framework.
///
/// This view represents the main screen of the application where the user can interact with the functionality related to the ingredients.
/// It holds a `MonitorStoreWrapper` as a state object to handle changes in the ingredient storage and fetch state data.
///
/// The body of the view includes scrollable elements, text, and buttons styled with the application theme. It sets up a vertical stack (`VStack`) containing all the elements
/// within the body and utilises the `onAppear` view modifier to dispatch a refresh action when the view appears.
///
/// The private function `storeIngredient` is used to dispatch the action of storing an ingredient. It computes the expiry duration of an ingredient
/// and dispatches the action to the `MonitorStoreWrapper` state object. Then, it dispatches a refresh action to ensure that the state is updated.
///
/// Note: The integers 1000000000 and 2 in the duration calculation are specifically for Swift language conversion from days to nanoseconds.
///
/// This view doesn't manage other view objects; instead, it controls how these embedded views interact together, outlining the visual structure and flow of Swift's UI interface.

struct HomeScreen: View {
	@StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()

	let greet = "Hello"

	var body: some View {

		let ingredients: [Ingredient] = store.state.ingredients
		VStack {
			ScrollView {
				VStack(spacing: 16) {
					Spacer(minLength: 40)

					Text(store.sideEffect?.description ?? "")
					Text("Fridge Storage")
							.typography(.h2)
							.padding()
							.frame(maxWidth: .infinity, alignment: .leading)

					ThemeButton(text: "Store Ingredient",
						image: Image(systemName: "plus.circle"),
						style: .fill,
						action: { storeIngredient() }
					)

					let columns = [
						GridItem(.flexible()),
						GridItem(.flexible())
					]
					LazyVStack {
						ForEach(ingredients, id: \.self.hashValue) { ingredient in
							StoredIngredient(imageUrl: ingredient.image,
								name: ingredient.name,
								totalDays: ingredient.totalDurationInDays(),
								remaingDays:
								ingredient.durationUntilExpiry(),
								progress: ingredient.expiryProgress())
						}
					}

				}
						.padding(16)
			}
		}
				.onAppear {
					store.dispatch(MonitorAction.Refresh())
				}

	}

	private func storeIngredient() {
		//1000000000 and 2 are for Swift
		let durationPerDay = 24 * 60 * 60 * 1000000000 * 2
		store.dispatch(
			MonitorAction.StoreIngredient(
				autocompleteIngredient: Shared.AutocompleteIngredient(
					id: 9266,
					image: "https://loremflickr.com/640/480",
					name: "Carrot"),
				expiryDuration: Int64(10 * durationPerDay))
		)
		store.dispatch(MonitorAction.Refresh())
	}


}

struct HomeScreen_Previews: PreviewProvider {
	static var previews: some View {
		HomeScreen()
	}
}
