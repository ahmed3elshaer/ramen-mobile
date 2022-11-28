import SwiftUI
import shared

struct ContentView: View {
    @StateObject var store: MonitorStoreWrapper = MonitorStoreWrapper()

    let greet = "Hello"

	var body: some View {
        Text(store.state.progress.description)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
