import SwiftUI

@main
struct iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	var body: some Scene {
		WindowGroup {
            TabView {
                MonitorScreen()
                           .tabItem {
                               Image(systemName: "refrigerator.fill")
                               Text("Fridge")
                       }
                
                StoreIngredientsScreen()
                           .tabItem {
                               Image(systemName: "plus.circle")
                               Text("Store")
                       }
                       RecipeScreen()
                           .tabItem {
                               Image(systemName: "fork.knife.circle")
                               Text("Recipes")
                       }
            }
            .background(VisualEffect(style: .systemThinMaterial))
            .accentColor(Color.defaultPrimary)
		}
	}
}
