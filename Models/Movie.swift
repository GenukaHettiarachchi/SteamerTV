import Foundation

struct Movie: Identifiable, Codable {
    let id: String
    let title: String
    let year: Int
    let overview: String
    let posterURL: URL?
    let trailerURL: URL?
    let fullMovieURL: URL?
    let isUpcoming: Bool
}
