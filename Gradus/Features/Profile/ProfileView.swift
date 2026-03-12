import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var newActorName = ""
    @State private var newDirectorName = ""

    init(appContainer: AppContainer) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(
                store: appContainer.userProfileStore,
                movieService: appContainer.movieService
            )
        )
    }

    var body: some View {
        Form {
            ProfileSection(String(localized: "profile.stable_taste")) {
                Text(String(localized: "profile.preferred_genres"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Genre.allCases) { genre in
                    SelectableRow(
                        title: genre.displayName,
                        isSelected: viewModel.profile.stableSignals.preferredGenres.contains(genre)
                    ) {
                        viewModel.togglePreferredGenre(genre)
                    }
                }

                Text(String(localized: "profile.avoid_genres"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Genre.allCases) { genre in
                    SelectableRow(
                        title: genre.displayName,
                        isSelected: viewModel.profile.stableSignals.avoidGenres.contains(genre)
                    ) {
                        viewModel.toggleAvoidGenre(genre)
                    }
                }

                Text(String(localized: "profile.language_affinity"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Language.allCases) { language in
                    SelectableRow(
                        title: language.displayName,
                        isSelected: viewModel.profile.stableSignals.preferredLanguages.contains(language)
                    ) {
                        viewModel.togglePreferredLanguage(language)
                    }
                }

                Text(String(localized: "profile.avoid_languages"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Language.allCases) { language in
                    SelectableRow(
                        title: language.displayName,
                        isSelected: viewModel.profile.stableSignals.avoidLanguages.contains(language)
                    ) {
                        viewModel.toggleAvoidLanguage(language)
                    }
                }

                Picker(String(localized: "profile.pacing"), selection: $viewModel.profile.stableSignals.pacingPreference) {
                    ForEach(PacingPreference.allCases) { pacing in
                        Text(pacing.displayName).tag(pacing)
                    }
                }

                Picker(String(localized: "profile.complexity"), selection: $viewModel.profile.stableSignals.complexityPreference) {
                    ForEach(ComplexityPreference.allCases) { complexity in
                        Text(complexity.displayName).tag(complexity)
                    }
                }

                Text(String(localized: "profile.tone_preferences"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Tone.allCases) { tone in
                    SelectableRow(
                        title: tone.displayName,
                        isSelected: viewModel.profile.stableSignals.tonePreferences.contains(tone)
                    ) {
                        viewModel.toggleTone(tone)
                    }
                }

                Text(String(localized: "profile.narrative_styles"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(NarrativeStyle.allCases) { style in
                    SelectableRow(
                        title: style.displayName,
                        isSelected: viewModel.profile.stableSignals.narrativeStylePreferences.contains(style)
                    ) {
                        viewModel.toggleNarrativeStyle(style)
                    }
                }
            }

            ProfileSection(String(localized: "profile.situational_context")) {
                Picker(String(localized: "profile.current_mood"), selection: $viewModel.profile.situationalSignals.currentMood) {
                    ForEach(Mood.allCases) { mood in
                        Text(mood.displayName).tag(mood)
                    }
                }

                Picker(String(localized: "profile.watch_context"), selection: $viewModel.profile.situationalSignals.watchContext) {
                    ForEach(WatchContext.allCases) { context in
                        Text(context.displayName).tag(context)
                    }
                }

                Stepper(
                    value: $viewModel.profile.situationalSignals.availableTimeMinutes,
                    in: 60...240,
                    step: 15
                ) {
                    Text(localizedFormat("profile.available_time_format", viewModel.profile.situationalSignals.availableTimeMinutes))
                }
            }

            ProfileSection(String(localized: "profile.content_boundaries")) {
                Text(String(localized: "profile.avoid_genres"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Genre.allCases) { genre in
                    SelectableRow(
                        title: genre.displayName,
                        isSelected: viewModel.profile.contentFilters.avoidGenres.contains(genre)
                    ) {
                        viewModel.profile.contentFilters.avoidGenres.toggle(genre)
                    }
                }

                Picker(String(localized: "profile.gore_sensitivity"), selection: $viewModel.profile.contentFilters.goreSensitivity) {
                    ForEach(GoreSensitivity.allCases) { sensitivity in
                        Text(sensitivity.displayName).tag(sensitivity)
                    }
                }

                Toggle(String(localized: "profile.avoid_very_long_movies"), isOn: $viewModel.profile.contentFilters.avoidVeryLongMovies)

                if viewModel.profile.contentFilters.avoidVeryLongMovies {
                    Stepper(
                        value: Binding(
                            get: { viewModel.profile.contentFilters.maxRuntimeMinutes ?? 150 },
                            set: { viewModel.profile.contentFilters.maxRuntimeMinutes = $0 }
                        ),
                        in: 90...240,
                        step: 15
                    ) {
                        Text(localizedFormat("profile.max_runtime_format", viewModel.profile.contentFilters.maxRuntimeMinutes ?? 150))
                    }
                }

                Text(String(localized: "profile.avoid_languages"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Language.allCases) { language in
                    SelectableRow(
                        title: language.displayName,
                        isSelected: viewModel.profile.contentFilters.avoidLanguages.contains(language)
                    ) {
                        viewModel.profile.contentFilters.avoidLanguages.toggle(language)
                    }
                }
            }

            ProfileSection(String(localized: "profile.explicit_favorites")) {
                favoritesHeader(title: String(localized: "profile.favorite_movies"), count: viewModel.profile.explicitFavorites.favoriteMovies.count)
                ForEach(viewModel.availableMovies) { movie in
                    let isSelected = viewModel.isFavoriteMovie(movie)
                    SelectableRow(
                        title: movie.title,
                        isSelected: isSelected
                    ) {
                        viewModel.toggleFavoriteMovie(movie)
                    }
                    .disabled(!isSelected && viewModel.profile.explicitFavorites.favoriteMovies.count >= 5)
                }

                favoritesHeader(title: String(localized: "profile.favorite_actors"), count: viewModel.profile.explicitFavorites.favoriteActors.count)
                HStack {
                    TextField(String(localized: "profile.add_actor"), text: $newActorName)
                    Button(String(localized: "profile.add_action")) {
                        viewModel.addFavoriteActor(name: newActorName)
                        newActorName = ""
                    }
                    .disabled(newActorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.profile.explicitFavorites.favoriteActors.count >= 5)
                }

                ForEach(viewModel.profile.explicitFavorites.favoriteActors) { actor in
                    HStack {
                        Text(actor.name)
                        Spacer()
                        Button {
                            viewModel.removeFavoriteActor(actor)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }

                favoritesHeader(title: String(localized: "profile.favorite_directors"), count: viewModel.profile.explicitFavorites.favoriteDirectors.count)
                HStack {
                    TextField(String(localized: "profile.add_director"), text: $newDirectorName)
                    Button(String(localized: "profile.add_action")) {
                        viewModel.addFavoriteDirector(name: newDirectorName)
                        newDirectorName = ""
                    }
                    .disabled(newDirectorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.profile.explicitFavorites.favoriteDirectors.count >= 5)
                }

                ForEach(viewModel.profile.explicitFavorites.favoriteDirectors) { director in
                    HStack {
                        Text(director.name)
                        Spacer()
                        Button {
                            viewModel.removeFavoriteDirector(director)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
        .navigationTitle(String(localized: "profile.title"))
    }

    private func favoritesHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(count)/5")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func localizedFormat(_ key: String, _ value: Int) -> String {
        String(format: NSLocalizedString(key, comment: ""), value)
    }
}

private extension Array where Element: Equatable {
    mutating func toggle(_ value: Element) {
        if let index = firstIndex(of: value) {
            remove(at: index)
        } else {
            append(value)
        }
    }
}
