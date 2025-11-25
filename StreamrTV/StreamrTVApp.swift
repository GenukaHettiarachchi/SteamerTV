//
//  StreamrTVApp.swift
//  StreamrTV
//
//  Created by ITSD on 2025-11-22.
//

import SwiftUI
import CoreData


@main
struct StreamrTVApp: App {
    @StateObject var wishlist = WishlistStore()
    @StateObject var subs = SubscriptionStore()

    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environmentObject(wishlist)
                .environmentObject(subs)
        }
    }
}
