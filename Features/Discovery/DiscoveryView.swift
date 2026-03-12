import SwiftUI

struct DiscoveryView: View {
    @StateObject private var viewModel: DiscoveryViewModel

    init(appContainer: AppContainer) {
        _viewModel = StateObject(
            wrappedValue: DiscoveryViewModel(movieService: appContainer.movieService)
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            if let movie = viewModel.currentMovie {
                MovieCardView(movie: movie)
                    .padding(.horizontal, 20)
            } else {
                emptyState
            }

            HStack(spacing: 16) {
                Button("Dislike") {
                    // Placeholder for swipe logic.
                }
                .buttonStyle(.bordered)

                Button("Like") {
                    // Placeholder for swipe logic.
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .task {
            if viewModel.movies.isEmpty {
                viewModel.loadMovies()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "film")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("No movies yet")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 40)
    }
}
