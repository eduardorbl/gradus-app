import Foundation
import Combine

@MainActor
final class DiscoveryViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var likedMovies: [Movie] = []
    @Published private(set) var dislikedMovies: [Movie] = []
    @Published private(set) var favoriteMovies: [Movie] = []
    @Published private(set) var historyMovies: [Movie] = []
    @Published private(set) var likedMovieIDs: Set<Int> = []
    @Published private(set) var dislikedMovieIDs: Set<Int> = []
    @Published private(set) var favoriteMovieIDs: Set<Int> = []

    private let movieService: MovieService
    private let interactionStore: MovieInteractionStore

    init(movieService: MovieService, interactionStore: MovieInteractionStore) {
        self.movieService = movieService
        self.interactionStore = interactionStore
    }

    var currentMovie: Movie? {
        guard movies.indices.contains(currentIndex) else { return nil }
        return movies[currentIndex]
    }

    func loadMovies() {
        movies = movieService.fetchMovies()
        currentIndex = 0
        refreshSnapshots()
    }

    func likeCurrent() {
        guard let movie = currentMovie else { return }
        interactionStore.like(movie.id)
        interactionStore.recordSeen(movie.id)
        refreshSnapshots()
        advance()
    }

    func dislikeCurrent() {
        guard let movie = currentMovie else { return }
        interactionStore.dislike(movie.id)
        interactionStore.recordSeen(movie.id)
        refreshSnapshots()
        advance()
    }

    func toggleWishlistCurrent() {
        guard let movie = currentMovie else { return }
        interactionStore.toggleFavorite(movie.id)
        refreshSnapshots()
    }

    func advance() {
        let nextIndex = currentIndex + 1
        if movies.indices.contains(nextIndex) {
            currentIndex = nextIndex
        } else {
            currentIndex = movies.count
        }
    }

    private func refreshSnapshots() {
        let byId = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
        likedMovieIDs = interactionStore.likedMovieIDs
        dislikedMovieIDs = interactionStore.dislikedMovieIDs
        favoriteMovieIDs = interactionStore.favoriteMovieIDs
        historyMovies = movies(from: interactionStore.historyMovieIDs, byId: byId)
        favoriteMovies = movies(from: interactionStore.favoriteMovieIDs, byId: byId)
        likedMovies = movies(from: interactionStore.likedMovieIDs, byId: byId)
        dislikedMovies = movies(from: interactionStore.dislikedMovieIDs, byId: byId)
    }

    private func movies(from ids: [Int], byId: [Int: Movie]) -> [Movie] {
        ids.compactMap { byId[$0] }
    }

    private func movies(from ids: Set<Int>, byId: [Int: Movie]) -> [Movie] {
        ids.sorted().compactMap { byId[$0] }
    }
}
