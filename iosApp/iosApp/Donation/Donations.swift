import SwiftUI
import StoreKit

class PaymentObserver: NSObject, SKPaymentTransactionObserver {
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		for transaction in transactions {
			switch transaction.transactionState {
			case .purchased:
				print("Transaction successful")
				queue.finishTransaction(transaction)
			case .failed, .restored:
				print("Transaction Failed")
				queue.finishTransaction(transaction)
			default:
				break
			}
		}
	}
}

struct DonationsView: View {
	@State private var paymentQueue: SKPaymentQueue? = nil
	@State private var gradientStart = UnitPoint(x: 0, y: 0)
	@State private var gradientEnd = UnitPoint(x: 1, y: 1)
	let paymentObserver = PaymentObserver()
	let gradientColors = Gradient(colors: [Color.blue, Color.purple])

	var body: some View {
		VStack {
			Text("Support Our Project").font(.largeTitle).fontWeight(.bold).padding()

			Text("We're building a personal recipe recommendation app, aimed to be both free and open source with no ads. We're still in early stages and there may be bugs. We'd appreciate your support, feedback, and testing.")
					.font(.body)
					.padding([.leading, .trailing])

			Button(action: {
				makeDonation()
			}) {
				HStack {
					Image(systemName: "heart.fill")
							.resizable()
							.frame(width: 20, height: 20)
							.foregroundColor(.white)
							.scaledToFit()
					Text("Donate").font(.title).foregroundColor(.white)
				}
			}
					.frame(minWidth: 0, maxWidth: 200)
					.padding()
					.background(LinearGradient(gradient: gradientColors, startPoint: gradientStart, endPoint: gradientEnd))
					.animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
					.cornerRadius(40)
					.onAppear {
						self.animateGradient()
					}
		}
				.onAppear {
					self.paymentQueue = SKPaymentQueue.default()
					self.paymentQueue?.add(paymentObserver)
				}
	}

	func animateGradient() {
		var start: CGFloat = 0
		var end: CGFloat = 1

		Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
			self.gradientStart = UnitPoint(x: start, y: start)
			self.gradientEnd = UnitPoint(x: end, y: end)

			start += 0.01
			end -= 0.01

			if (end <= 0) {
				start = 0
				end = 1
			}
		}
	}

	func makeDonation() {
		if (SKPaymentQueue.canMakePayments()) {
			let paymentRequest = SKMutablePayment()
			paymentRequest.productIdentifier = "com.ramen.ios"
			paymentQueue?.add(paymentRequest)
		}
	}
}