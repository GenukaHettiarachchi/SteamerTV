import SwiftUI

struct PurchaseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var subs: SubscriptionStore

    var body: some View {
        VStack(spacing: 30) {
            Text("Subscribe to MovieTV")
                .font(.largeTitle)
                .bold()

            Text("Get unlimited access to full movies.")
                .multilineTextAlignment(.center)

            Button("Subscribe Now") {
                subs.subscribe()
                dismiss()
            }
            .buttonStyle(.borderedProminent)

            Button("Close") {
                dismiss()
            }
        }
        .padding()
    }
}
