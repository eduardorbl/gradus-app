final class AppContainer {
    let movieService: MovieService

    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
}
