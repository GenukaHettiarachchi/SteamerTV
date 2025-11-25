import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var wishlist: WishlistStore
    @EnvironmentObject var subs: SubscriptionStore

    @State var showTrailer = false
    @State var showFull = false
    @State var showSubscribe = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            HStack {
                AsyncImage(url: movie.posterURL) { img in
                    img.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 350, height: 520)
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 15) {
                    Text(movie.title).font(.largeTitle).bold()
                    Text("\(movie.year)").font(.title2)
                    Text(movie.overview).font(.body).lineLimit(8)

                    HStack {
                        Button("Watch Trailer") {
                            showTrailer = true
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Watch Full") {
                            if subs.isSubscribed { showFull = true }
                            else { showSubscribe = true }
                        }
                        .buttonStyle(.bordered)
                    }

                    Button {
                        wishlist.toggle(movie)
                    } label: {
                        Label("Wishlist", systemImage: wishlist.contains(movie) ? "heart.fill" : "heart")
                    }
                }
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showTrailer) {
            if let url = movie.trailerURL {
                PlayerView(url: url)
            }
        }
        .sheet(isPresented: $showFull) {
            if let url = movie.fullMovieURL {
                PlayerView(url: url)
            }
        }
        .sheet(isPresented: $showSubscribe) {
            PurchaseView()
        }
    }
}
