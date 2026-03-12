import Foundation

final class MovieService {
    func fetchMovies() -> [Movie] {
        [
            Movie(
                id: 603,
                title: "The Matrix",
                overview: "A hacker discovers the world is a simulation and joins a rebellion.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg"),
                year: 1999,
                rating: 8.2,
                genres: ["Action", "Science Fiction"]
            ),
            Movie(
                id: 27205,
                title: "Inception",
                overview: "A thief enters dreams to steal secrets and is offered a chance at redemption.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg"),
                year: 2010,
                rating: 8.4,
                genres: ["Action", "Science Fiction", "Thriller"]
            ),
            Movie(
                id: 157336,
                title: "Interstellar",
                overview: "Explorers travel through a wormhole to find a new home for humanity.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"),
                year: 2014,
                rating: 8.4,
                genres: ["Adventure", "Drama", "Science Fiction"]
            )
        ]
    }
}
