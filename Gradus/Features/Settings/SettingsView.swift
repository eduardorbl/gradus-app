import SwiftUI

struct SettingsView: View {
    let appContainer: AppContainer
    let historyMovies: [Movie]
    let favoriteMovies: [Movie]
    let likedMovies: [Movie]
    let dislikedMovies: [Movie]

    @AppStorage("app_language") private var appLanguage: AppLanguage = .system

    var body: some View {
        List {
            Section {
                NavigationLink(String(localized: "settings.profile")) {
                    ProfileView(appContainer: appContainer)
                }
            }

            Section(String(localized: "settings.language_section")) {
                Picker(String(localized: "settings.app_language"), selection: $appLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.displayName).tag(language)
                    }
                }
            }

            historySection(title: String(localized: "settings.history"), movies: historyMovies)
            historySection(title: String(localized: "settings.wish_list"), movies: favoriteMovies)
            historySection(title: String(localized: "settings.nice_now"), movies: likedMovies)
            historySection(title: String(localized: "settings.not_nice_now"), movies: dislikedMovies)
        }
        .navigationTitle(String(localized: "settings.title"))
        .listStyle(.insetGrouped)
    }

    private func historySection(title: String, movies: [Movie]) -> some View {
        Section(title) {
            if movies.isEmpty {
                Text(String(localized: "common.empty"))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(movies) { movie in
                    HStack {
                        Text(movie.title)
                        Spacer()
                        if let year = movie.year {
                            Text(String(year))
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}
