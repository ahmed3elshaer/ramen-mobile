import SwiftUI

struct DonationsView: View {
    var body: some View {
        ZStack {
            // Background gradient
            Color.background.edgesIgnoringSafeArea(.all)

            // Main content
            VStack {
                Spacer()

                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.gradientStart, Color.gradientMiddle, Color.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))

                    Text("Stirring Up Open Source Flavor! ")
                        .typography(.h2)
                        .foregroundColor(.fontStd)
                        .padding()
                }

                Text("Your donations help us keep the kitchen creative and our code cupboard open. Let's cook up something great together! 🧡")
                    .typography(.h5)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.gradientStart, Color.gradientMiddle, Color.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding()

                Spacer()

                ThemeButton(text: "Text", image: Image(systemName: "arrow.right"), action: { print("click") })
                    .padding()
            }
        }
    }
}



struct DonationsView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsView()
    }
}
