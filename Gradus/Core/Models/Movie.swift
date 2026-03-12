import Foundation

struct Movie: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let year: Int?
    let rating: Double
    let genres: [String]

    init(
        id: Int,
        title: String,
        overview: String,
        posterURL: URL?,
        year: Int?,
        rating: Double,
        genres: [String] = []
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURL = posterURL
        self.year = year
        self.rating = rating
        self.genres = genres
    }
}
