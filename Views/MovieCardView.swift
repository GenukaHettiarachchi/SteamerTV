import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @EnvironmentObject var wishlist: WishlistStore

    var body: some View {
        VStack {
            AsyncImage(url: movie.posterURL) { img in
                img.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 350, height: 520)
            .cornerRadius(12)

            Text(movie.title)
                .font(.title3)
                .padding(.top, 8)

            Button {
                wishlist.toggle(movie)
            } label: {
                Image(systemName: wishlist.contains(movie) ? "heart.fill" : "heart")
                    .font(.title2)
            }
        }
        .focusable()
    }
}
