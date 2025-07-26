import SwiftUI

@main
struct iOSApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	var body: some Scene {
		WindowGroup {
            TabView {
                Tab {
                    MonitorScreen()
                } label : {
                    Label("Fridge", systemImage: "refrigerator.fill")
                }
                
                Tab {
                    RecipeScreen()
                } label : {
                    Label("Recipes", systemImage: "fork.knife.circle")
                }
				
                Tab(role:.search){
                    StoreIngredientsScreen()
                }
			}
            .accentColor(Color.defaultPrimary)
		}
	}
}
