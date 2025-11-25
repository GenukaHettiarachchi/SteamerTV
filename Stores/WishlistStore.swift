import Foundation
import SwiftUI
import Combine

class WishlistStore: ObservableObject {
    private let wishlistKey = "wishlist"
    private var saved: Data {
        get { UserDefaults.standard.data(forKey: wishlistKey) ?? Data() }
        set { UserDefaults.standard.set(newValue, forKey: wishlistKey) }
    }
    @Published var items: Set<String> = []

    init() { load() }

    func load() {
        if let decoded = try? JSONDecoder().decode([String].self, from: saved) {
            items = Set(decoded)
        }
    }

    func save() {
        saved = (try? JSONEncoder().encode(Array(items))) ?? Data()
    }

    func toggle(_ movie: Movie) {
        if items.contains(movie.id) { items.remove(movie.id) }
        else { items.insert(movie.id) }
        save()
    }

    func contains(_ movie: Movie) -> Bool {
        items.contains(movie.id)
    }
}
