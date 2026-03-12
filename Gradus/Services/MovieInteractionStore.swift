protocol MovieInteractionStore {
    var likedMovieIDs: Set<Int> { get }
    var dislikedMovieIDs: Set<Int> { get }
    var favoriteMovieIDs: Set<Int> { get }
    var historyMovieIDs: [Int] { get }

    func like(_ id: Int)
    func dislike(_ id: Int)
    func toggleFavorite(_ id: Int)
    func recordSeen(_ id: Int)
}

final class InMemoryMovieInteractionStore: MovieInteractionStore {
    private(set) var likedMovieIDs: Set<Int> = []
    private(set) var dislikedMovieIDs: Set<Int> = []
    private(set) var favoriteMovieIDs: Set<Int> = []
    private(set) var historyMovieIDs: [Int] = []

    func like(_ id: Int) {
        likedMovieIDs.insert(id)
        dislikedMovieIDs.remove(id)
    }

    func dislike(_ id: Int) {
        dislikedMovieIDs.insert(id)
        likedMovieIDs.remove(id)
    }

    func toggleFavorite(_ id: Int) {
        if favoriteMovieIDs.contains(id) {
            favoriteMovieIDs.remove(id)
        } else {
            favoriteMovieIDs.insert(id)
        }
    }

    func recordSeen(_ id: Int) {
        guard !historyMovieIDs.contains(id) else { return }
        historyMovieIDs.append(id)
    }
}
