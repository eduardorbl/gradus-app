import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published private(set) var availableMovies: [Movie] = []

    private let store: UserProfileStore
    private let movieService: MovieService
    private var cancellables: Set<AnyCancellable> = []

    init(store: UserProfileStore, movieService: MovieService) {
        self.store = store
        self.movieService = movieService
        self.profile = store.load()
        self.availableMovies = movieService.fetchMovies()
        syncStableFavorites()
        bindPersistence()
    }

    func togglePreferredGenre(_ genre: Genre) {
        toggle(genre, in: &profile.stableSignals.preferredGenres)
    }

    func toggleAvoidGenre(_ genre: Genre) {
        toggle(genre, in: &profile.stableSignals.avoidGenres)
    }

    func togglePreferredLanguage(_ language: Language) {
        toggle(language, in: &profile.stableSignals.preferredLanguages)
    }

    func toggleAvoidLanguage(_ language: Language) {
        toggle(language, in: &profile.stableSignals.avoidLanguages)
    }

    func toggleTone(_ tone: Tone) {
        toggle(tone, in: &profile.stableSignals.tonePreferences)
    }

    func toggleNarrativeStyle(_ style: NarrativeStyle) {
        toggle(style, in: &profile.stableSignals.narrativeStylePreferences)
    }

    func isFavoriteMovie(_ movie: Movie) -> Bool {
        profile.explicitFavorites.favoriteMovies.contains { $0.id == movie.id }
    }

    func toggleFavoriteMovie(_ movie: Movie) {
        if isFavoriteMovie(movie) {
            profile.explicitFavorites.favoriteMovies.removeAll { $0.id == movie.id }
        } else if profile.explicitFavorites.favoriteMovies.count < 5 {
            profile.explicitFavorites.favoriteMovies.append(
                FavoriteMovie(
                    id: movie.id,
                    title: movie.title,
                    year: movie.year,
                    posterURL: movie.posterURL
                )
            )
        }
        syncStableFavorites()
    }

    func addFavoriteActor(name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard profile.explicitFavorites.favoriteActors.count < 5 else { return }
        profile.explicitFavorites.favoriteActors.append(FavoriteActor(name: name))
        syncStableFavorites()
    }

    func removeFavoriteActor(_ actor: FavoriteActor) {
        profile.explicitFavorites.favoriteActors.removeAll { $0.id == actor.id }
        syncStableFavorites()
    }

    func addFavoriteDirector(name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard profile.explicitFavorites.favoriteDirectors.count < 5 else { return }
        profile.explicitFavorites.favoriteDirectors.append(FavoriteDirector(name: name))
        syncStableFavorites()
    }

    func removeFavoriteDirector(_ director: FavoriteDirector) {
        profile.explicitFavorites.favoriteDirectors.removeAll { $0.id == director.id }
        syncStableFavorites()
    }

    private func toggle<T: Equatable>(_ value: T, in array: inout [T]) {
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        } else {
            array.append(value)
        }
    }

    private func bindPersistence() {
        $profile
            .dropFirst()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] profile in
                self?.persist(profile)
            }
            .store(in: &cancellables)
    }

    private func persist(_ profile: UserProfile) {
        store.save(profile)
    }

    private func syncStableFavorites() {
        profile.stableSignals.favoriteActors = profile.explicitFavorites.favoriteActors
        profile.stableSignals.favoriteDirectors = profile.explicitFavorites.favoriteDirectors
    }
}
