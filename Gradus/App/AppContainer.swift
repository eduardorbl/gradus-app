final class AppContainer {
    let movieService: MovieService
    let interactionStore: MovieInteractionStore
    let userProfileStore: UserProfileStore

    init(
        movieService: MovieService = MovieService(),
        interactionStore: MovieInteractionStore = InMemoryMovieInteractionStore(),
        userProfileStore: UserProfileStore = FileUserProfileStore()
    ) {
        self.movieService = movieService
        self.interactionStore = interactionStore
        self.userProfileStore = userProfileStore
    }
}
