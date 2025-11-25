import SwiftUI

struct MovieListView: View {
    @StateObject var service = MovieService.shared
    @EnvironmentObject var wishlist: WishlistStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {

                    Text("Upcoming")
                        .font(.largeTitle)
                        .bold()

                    ScrollView(.horizontal) {
                        HStack(spacing: 40) {
                            ForEach(service.movies.filter { $0.isUpcoming }) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieCardView(movie: movie)
                                        .focusable(true)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("All Movies")
                        .font(.largeTitle)
                        .bold()

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 350))]) {
                        ForEach(service.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieCardView(movie: movie)
                                    .focusable(true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MovieTV")
        }
    }
}
