# StreamrTV

StreamrTV is a tvOS application built with SwiftUI that showcases a catalog of movies, allowing users to:

- **Browse upcoming and available movies**
- **View detailed information** about each title
- **Watch trailers and full movies** (via provided URLs)
- **Manage a persistent wishlist** of favorite titles
- **Simulate subscription access** for full‑length content

This app is structured as a small, focused streaming UI prototype suitable for learning SwiftUI on tvOS or demonstrating app architecture for a media app.

---

## Tech Stack

- **Platform:** tvOS
- **Language:** Swift
- **UI Framework:** SwiftUI (+ `NavigationStack`, `AsyncImage`)
- **Media Playback:** AVKit (`AVPlayerViewController` via `UIViewControllerRepresentable`)
- **State Management:** `ObservableObject`, `@StateObject`, `@EnvironmentObject`, `@Published`
- **Persistence:** `UserDefaults` (for wishlist IDs)
- **Data Source:** Local JSON file (`movies.json` bundled in the app)

---

## Features

- **Movie catalog**
  - `MovieListView` loads movies from `MovieService` and displays them in:
    - An **Upcoming** horizontal carousel (movies where `isUpcoming == true`)
    - An **All Movies** grid using `LazyVGrid` for a tiled layout.

- **Movie details**
  - `MovieDetailView` shows:
    - Poster image (via `AsyncImage`)
    - Title, release year, and overview
    - Actions:
      - **Watch Trailer** – opens `PlayerView` in a sheet using the movie `trailerURL`.
      - **Watch Full** – opens `PlayerView` with `fullMovieURL` if subscribed, or shows a subscription sheet.
      - **Wishlist toggle** – adds/removes the movie from the wishlist (with `heart` / `heart.fill` icon).

- **Wishlist**
  - `WishlistView` shows the user’s saved titles.
  - Uses `WishlistStore` to keep a `Set<String>` of movie IDs in `UserDefaults`.
  - Filters the main movie list to only show items present in `wishlist.items`.

- **Subscription flow (simulated)**
  - `SubscriptionStore` tracks `isSubscribed` and exposes `subscribe()` / `unsubscribe()`.
  - `PurchaseView` is a simple paywall sheet:
    - "Subscribe Now" sets `isSubscribed = true` and dismisses.
    - "Close" dismisses without changing state.
  - By default in this project, `isSubscribed` starts as `true`, so full movies are accessible.

- **Video playback**
  - `PlayerView` bridges UIKit `AVPlayerViewController` into SwiftUI to play the provided video `URL`.
  - Automatically starts playback on presentation.

---

## Architecture Overview

The app is organized by responsibility into **Models**, **Views**, **Stores**, and **Services**:

- **Entry point**
  - `StreamrTVApp` (`@main`):
    - Creates and injects shared state objects:
      - `WishlistStore()`
      - `SubscriptionStore()`
    - Root view: `MovieListView()`
    - Passes stores via `.environmentObject(...)` so all child views can access them.

- **Models** (`Models/`)
  - `Movie`:
    - `id: String`
    - `title: String`
    - `year: Int`
    - `overview: String`
    - `posterURL: URL?`
    - `trailerURL: URL?`
    - `fullMovieURL: URL?`
    - `isUpcoming: Bool`
    - Conforms to `Identifiable` and `Codable` for use in lists and JSON decoding.

- **Views** (`Views/`)
  - `MovieListView`: Main catalog screen with Upcoming + All Movies sections.
  - `MovieDetailView`: Details, playback actions, and wishlist button.
  - `WishlistView`: List of wishlisted movies.
  - `PurchaseView`: Subscription / paywall UI.
  - `PlayerView`: `UIViewControllerRepresentable` wrapper around `AVPlayerViewController`.
  - (If present) `MovieCardView`: Card UI for individual movies in lists/grids.

- **Stores** (`Stores/`)
  - `WishlistStore` (`ObservableObject`):
    - Persists a set of movie IDs using `UserDefaults`.
    - API:
      - `toggle(_ movie: Movie)` – add/remove ID, then save.
      - `contains(_ movie: Movie) -> Bool` – helper for UI state.
  - `SubscriptionStore` (`ObservableObject`, `@MainActor`):
    - Holds `@Published var isSubscribed: Bool`.
    - API: `subscribe()`, `unsubscribe()`.

- **Services** (`Services/`)
  - `MovieService` (`ObservableObject`):
    - Singleton via `static let shared`.
    - Exposes `@Published var movies: [Movie]`.
    - Loads local JSON from the app bundle using `loadLocal()`.
    - Includes detailed logging for missing file, JSON decode errors, and success.

---

## Data Loading (`movies.json`)

`MovieService` expects a `movies.json` file in the app bundle.

- The file is looked up via `Bundle.main.url(forResource: "movies", withExtension: "json")`.
- The JSON is decoded into `[Movie]` using `JSONDecoder`.
- All errors are printed with helpful explanations (e.g. key mismatch, type mismatch).

**Important for Xcode:**

- Ensure `movies.json` exists (likely under `Resources/`).
- In the File Inspector, verify that **Target Membership** includes the `StreamrTV` target so it is bundled with the app.

---

## How to Run the App

1. **Open the project**
   - Double‑click `StreamrTV.xcodeproj` to open in Xcode.

2. **Select the scheme and destination**
   - Choose the `StreamrTV` scheme.
   - Select a **tvOS Simulator** device (e.g. "Apple TV 4K").

3. **Build and run**
   - Press **⌘R** or click the **Run** button.
   - The tvOS simulator should launch and show the main `MovieListView` screen.

4. **Navigate in the simulator**
   - Use the simulated remote / keyboard arrow keys to move focus.
   - Press **Enter/Return** to select a movie card and open its details.
   - Try:
     - Opening **Upcoming** titles.
     - Watching a **trailer**.
     - Watching **full movies** (depending on `isSubscribed`).
     - Adding/removing items from the **Wishlist**.

---

## Notes & Limitations

- This is a **demo / prototype** app, not a production streaming client.
- Subscription handling is purely local state and does not contact any backend.
- Video playback relies on the `URL` fields in `Movie` being valid and reachable.
- Wishlist persistence is simple `UserDefaults`; there is no syncing between devices.

---

## Possible Future Improvements

- Integrate a real backend for movie data instead of local JSON.
- Implement real subscription / in‑app purchase flows.
- Add search and filtering capabilities.
- Improve TV‑optimized UI (top shelf content, richer focus states, etc.).
- Add unit tests for `MovieService`, `WishlistStore`, and `SubscriptionStore`.
