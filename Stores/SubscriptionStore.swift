import Foundation
import SwiftUI
import Combine

@MainActor
final class SubscriptionStore: ObservableObject {
    // Always allow access: no subscription gating
    @Published var isSubscribed: Bool = true

    init() {}

    // Public API used by views
    func subscribe() {
        isSubscribed = true
    }

    func unsubscribe() {
        isSubscribed = false
    }
}
