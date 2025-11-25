import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var wishlist: WishlistStore
    @StateObject var service = MovieService.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Wishlist").font(.largeTitle).bold()

                ForEach(service.movies.filter { wishlist.items.contains($0.id) }) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            AsyncImage(url: movie.posterURL) { img in
                                img.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 120, height: 180)
                            .cornerRadius(8)

                            Text(movie.title).font(.title2)
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
    }
}
