import SwiftUI

struct DiscoveryView: View {
    @StateObject private var viewModel: DiscoveryViewModel
    private let appContainer: AppContainer
    @State private var dragOffset: CGSize = .zero
    @State private var isDescriptionPresented = false
    @State private var feedbackOverlay: FeedbackOverlay?
    @State private var isFeedbackVisible = false

    init(appContainer: AppContainer) {
        self.appContainer = appContainer
        _viewModel = StateObject(
            wrappedValue: DiscoveryViewModel(
                movieService: appContainer.movieService,
                interactionStore: appContainer.interactionStore
            )
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    if let movie = viewModel.currentMovie {
                        MovieCardView(
                            movie: movie,
                            isWishlisted: viewModel.favoriteMovieIDs.contains(movie.id)
                        )
                            .padding(.horizontal, 20)
                            .offset(dragOffset)
                            .gesture(dragGesture)
                            .onTapGesture {
                                isDescriptionPresented = true
                            }
                            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: dragOffset)
                            .overlay {
                                if let feedbackOverlay, isFeedbackVisible {
                                    feedbackView(for: feedbackOverlay)
                                        .transition(.opacity.combined(with: .scale))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                    } else {
                        emptyState
                    }

                    VStack(spacing: 8) {
                        swipeGuidelines
                    }
                    .padding(.bottom, 12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(
                            appContainer: appContainer,
                            historyMovies: viewModel.historyMovies,
                            favoriteMovies: viewModel.favoriteMovies,
                            likedMovies: viewModel.likedMovies,
                            dislikedMovies: viewModel.dislikedMovies
                        )
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .task {
            if viewModel.movies.isEmpty {
                viewModel.loadMovies()
            }
        }
        .sheet(isPresented: $isDescriptionPresented) {
            descriptionSheet
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "film")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(String(localized: "discovery.no_movies"))
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 40)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let translation = value.translation
                let horizontal = translation.width
                let vertical = translation.height
                let isHorizontal = abs(horizontal) > abs(vertical)
                let horizontalThreshold: CGFloat = 120
                let verticalThreshold: CGFloat = 120

                if isHorizontal {
                    if horizontal > horizontalThreshold {
                        showFeedback(.like)
                        viewModel.likeCurrent()
                    } else if horizontal < -horizontalThreshold {
                        showFeedback(.dislike)
                        viewModel.dislikeCurrent()
                    }
                } else {
                    if vertical > verticalThreshold {
                        let wasFavorite = viewModel.currentMovie.map { viewModel.favoriteMovieIDs.contains($0.id) } ?? false
                        viewModel.toggleWishlistCurrent()
                        if !wasFavorite {
                            showFeedback(.wishlist)
                        }
                    }
                }

                dragOffset = .zero
            }
    }

    private var descriptionSheet: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let movie = viewModel.currentMovie {
                Text(movie.title)
                    .font(.title2.weight(.semibold))

                HStack(spacing: 8) {
                    if let year = movie.year {
                        Text(String(year))
                    }
                    Text(String(format: NSLocalizedString("discovery.rating_format", comment: ""), movie.rating))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Text(movie.overview)
                    .font(.body)
                    .foregroundStyle(.primary)

                if !movie.genres.isEmpty {
                    Text(movie.genres.joined(separator: " • "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(String(localized: "discovery.no_movie_selected"))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var swipeGuidelines: some View {
        HStack(spacing: 12) {
            guidelineItem(
                systemImage: "arrow.left",
                text: String(localized: "guideline.not_nice")
            )
            guidelineItem(
                systemImage: "arrow.up",
                text: String(localized: "guideline.details")
            )
            guidelineItem(
                systemImage: "arrow.down",
                text: String(localized: "guideline.wish_list")
            )
            guidelineItem(
                systemImage: "arrow.right",
                text: String(localized: "guideline.nice")
            )
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }

    private func guidelineItem(systemImage: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
            Text(text)
        }
    }

    private var backgroundColor: Color {
        let translation = dragOffset
        let horizontal = translation.width
        let vertical = translation.height
        let isHorizontal = abs(horizontal) > abs(vertical)
        let threshold: CGFloat = 40

        if isHorizontal {
            if horizontal > threshold {
                return Color.green.opacity(0.08)
            } else if horizontal < -threshold {
                return Color.red.opacity(0.08)
            }
        } else {
            if vertical < -threshold {
                return Color.blue.opacity(0.08)
            } else if vertical > threshold {
                return Color.yellow.opacity(0.08)
            }
        }

        return Color(.systemGroupedBackground)
    }

    private func showFeedback(_ overlay: FeedbackOverlay) {
        feedbackOverlay = overlay
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            isFeedbackVisible = true
        }

        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            withAnimation(.easeOut(duration: 0.2)) {
                isFeedbackVisible = false
            }
            try? await Task.sleep(nanoseconds: 250_000_000)
            feedbackOverlay = nil
        }
    }

    private func feedbackView(for overlay: FeedbackOverlay) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(overlay.color.opacity(0.18))

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(overlay.color.opacity(0.6), lineWidth: 2)

            VStack(spacing: 6) {
                Image(systemName: overlay.systemImage)
                    .font(.system(size: 34, weight: .bold))
                Text(overlay.title)
                    .font(.headline.weight(.semibold))
            }
            .foregroundStyle(overlay.color)
        }
        .padding(28)
    }
}

private enum FeedbackOverlay {
    case like
    case dislike
    case wishlist

    var title: String {
        switch self {
        case .like:
            return String(localized: "feedback.nice")
        case .dislike:
            return String(localized: "feedback.not_nice")
        case .wishlist:
            return String(localized: "feedback.wishlisted")
        }
    }

    var systemImage: String {
        switch self {
        case .like:
            return "hand.thumbsup.fill"
        case .dislike:
            return "hand.thumbsdown.fill"
        case .wishlist:
            return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .like:
            return .green
        case .dislike:
            return .red
        case .wishlist:
            return .yellow
        }
    }
}
