import Foundation

@MainActor
final class DiscoveryViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var currentIndex: Int = 0

    private let movieService: MovieService

    init(movieService: MovieService) {
        self.movieService = movieService
    }

    var currentMovie: Movie? {
        guard movies.indices.contains(currentIndex) else { return nil }
        return movies[currentIndex]
    }

    func loadMovies() {
        movies = movieService.fetchMovies()
        currentIndex = 0
    }
}
