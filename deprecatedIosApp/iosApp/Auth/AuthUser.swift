import AuthenticationServices
import Foundation
import SwiftUI

struct AuthUser: View {
	@State private var hue: Double = 0
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color(hue: hue, saturation: 0.6, brightness: 0.8),
													   Color(hue: hue + 0.3, saturation: 0.6, brightness: 0.7),
													   Color(hue: hue + 0.3, saturation: 0.6, brightness: 0.8)]),
				startPoint: .topLeading, endPoint: .bottomTrailing)
					.animation(.default)
					.edgesIgnoringSafeArea(.all)
					.onReceive(timer) { _ in
						self.hue = (self.hue + 0.01).truncatingRemainder(dividingBy: 1)
					}

			VStack(spacing: 20) {
				SignInWithAppleButton(.signIn, onRequest: handleAppleSignInRequest, onCompletion: handleAppleSignInResult)
						.frame(width: 280, height: 44)
						.padding()

				GoogleLoginButton()
						.frame(width: 280, height: 44)
						.background(Color.white)
						.cornerRadius(8)
						.padding()

				FacebookLoginButton()
						.frame(width: 280, height: 44)
						.background(Color.white)
						.cornerRadius(8)
						.padding()
			}
		}
	}

	private func handleAppleSignInRequest(request _: ASAuthorizationAppleIDRequest) {
		// Handle Apple sign in request
	}

	private func handleAppleSignInResult(result _: Result<ASAuthorization, Error>) {
		// Handle Apple sign in result
	}

	private struct GoogleLoginButton: View {
		var body: some View {
			Button(action: {
				// Handle Google sign in
			}) {
				HStack {
					Image(systemName: "globe") // Substitute with an appropriate Google logo
					Text("Continue with Google")
				}
			}
		}
	}

	private struct FacebookLoginButton: View {
		var body: some View {
			Button(action: {
				// Handle Facebook sign in
			}) {
				HStack {
					Image(systemName: "f.circle") // Substitute with an appropriate Facebook logo
					Text("Continue with Facebook")
				}
			}
		}
	}
}

struct AuthUser_Previews: PreviewProvider {
	static var previews: some View {
		AuthUser()
	}
}
