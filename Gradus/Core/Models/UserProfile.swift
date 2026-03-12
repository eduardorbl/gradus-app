import Foundation

// MARK: - User Profile Models
// These models are designed to capture structured preference signals that can be
// converted into a user taste vector for recommendations.
//
// Example vectorization:
// - Genres -> genre affinity weights
// - Actors/Directors -> talent affinity weights
// - Languages -> language affinity weights
// - Pacing/Complexity/Tone -> stylistic preference weights
// - Available time/runtime -> runtime suitability score
// - Content filters -> hard constraints in candidate selection

struct UserProfile: Codable, Hashable {
    var stableSignals: StableTasteSignals
    var situationalSignals: SituationalContext
    var contentFilters: ContentFilters
    var explicitFavorites: ExplicitFavorites

    static var empty: UserProfile {
        UserProfile(
            stableSignals: .empty,
            situationalSignals: .empty,
            contentFilters: .empty,
            explicitFavorites: .empty
        )
    }

    static var mock: UserProfile {
        UserProfile(
            stableSignals: StableTasteSignals(
                preferredGenres: [.scienceFiction, .adventure],
                avoidGenres: [.horror],
                preferredLanguages: [.english],
                avoidLanguages: [],
                tonePreferences: [.mindBending, .emotional],
                narrativeStylePreferences: [.linear, .slowBurn],
                pacingPreference: .balanced,
                complexityPreference: .complex,
                favoriteActors: [FavoriteActor(name: "Matthew McConaughey")],
                favoriteDirectors: [FavoriteDirector(name: "Christopher Nolan")]
            ),
            situationalSignals: SituationalContext(
                currentMood: .mindBending,
                watchContext: .alone,
                availableTimeMinutes: 150
            ),
            contentFilters: ContentFilters(
                avoidGenres: [.horror],
                avoidLanguages: [],
                goreSensitivity: .medium,
                avoidVeryLongMovies: false,
                maxRuntimeMinutes: nil
            ),
            explicitFavorites: ExplicitFavorites(
                favoriteMovies: [
                    FavoriteMovie(id: 157336, title: "Interstellar", year: 2014, posterURL: nil)
                ],
                favoriteActors: [FavoriteActor(name: "Matthew McConaughey")],
                favoriteDirectors: [FavoriteDirector(name: "Christopher Nolan")]
            )
        )
    }
}

struct StableTasteSignals: Codable, Hashable {
    var preferredGenres: [Genre]
    var avoidGenres: [Genre]
    var preferredLanguages: [Language]
    var avoidLanguages: [Language]
    var tonePreferences: [Tone]
    var narrativeStylePreferences: [NarrativeStyle]
    var pacingPreference: PacingPreference
    var complexityPreference: ComplexityPreference
    var favoriteActors: [FavoriteActor]
    var favoriteDirectors: [FavoriteDirector]

    static var empty: StableTasteSignals {
        StableTasteSignals(
            preferredGenres: [],
            avoidGenres: [],
            preferredLanguages: [],
            avoidLanguages: [],
            tonePreferences: [],
            narrativeStylePreferences: [],
            pacingPreference: .balanced,
            complexityPreference: .medium,
            favoriteActors: [],
            favoriteDirectors: []
        )
    }
}

struct SituationalContext: Codable, Hashable {
    var currentMood: Mood
    var watchContext: WatchContext
    var availableTimeMinutes: Int

    static var empty: SituationalContext {
        SituationalContext(
            currentMood: .neutral,
            watchContext: .alone,
            availableTimeMinutes: 120
        )
    }
}

struct ContentFilters: Codable, Hashable {
    var avoidGenres: [Genre]
    var avoidLanguages: [Language]
    var goreSensitivity: GoreSensitivity
    var avoidVeryLongMovies: Bool
    var maxRuntimeMinutes: Int?

    static var empty: ContentFilters {
        ContentFilters(
            avoidGenres: [],
            avoidLanguages: [],
            goreSensitivity: .low,
            avoidVeryLongMovies: false,
            maxRuntimeMinutes: nil
        )
    }
}

struct ExplicitFavorites: Codable, Hashable {
    var favoriteMovies: [FavoriteMovie]
    var favoriteActors: [FavoriteActor]
    var favoriteDirectors: [FavoriteDirector]

    static var empty: ExplicitFavorites {
        ExplicitFavorites(
            favoriteMovies: [],
            favoriteActors: [],
            favoriteDirectors: []
        )
    }
}

struct FavoriteMovie: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let year: Int?
    let posterURL: URL?
}

struct FavoriteActor: Codable, Hashable, Identifiable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

struct FavoriteDirector: Codable, Hashable, Identifiable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

enum Genre: String, CaseIterable, Codable, Identifiable {
    case action = "Action"
    case adventure = "Adventure"
    case animation = "Animation"
    case comedy = "Comedy"
    case crime = "Crime"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case romance = "Romance"
    case scienceFiction = "Science Fiction"
    case thriller = "Thriller"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .action: return "genre.action"
        case .adventure: return "genre.adventure"
        case .animation: return "genre.animation"
        case .comedy: return "genre.comedy"
        case .crime: return "genre.crime"
        case .drama: return "genre.drama"
        case .fantasy: return "genre.fantasy"
        case .horror: return "genre.horror"
        case .romance: return "genre.romance"
        case .scienceFiction: return "genre.science_fiction"
        case .thriller: return "genre.thriller"
        }
    }
}

enum Tone: String, CaseIterable, Codable, Identifiable {
    case feelGood = "Feel Good"
    case dark = "Dark"
    case mindBending = "Mind-Bending"
    case emotional = "Emotional"
    case tense = "Tense"
    case uplifting = "Uplifting"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .feelGood: return "tone.feel_good"
        case .dark: return "tone.dark"
        case .mindBending: return "tone.mind_bending"
        case .emotional: return "tone.emotional"
        case .tense: return "tone.tense"
        case .uplifting: return "tone.uplifting"
        }
    }
}

enum NarrativeStyle: String, CaseIterable, Codable, Identifiable {
    case linear = "Linear"
    case nonlinear = "Nonlinear"
    case slowBurn = "Slow Burn"
    case twisty = "Twisty"
    case contemplative = "Contemplative"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .linear: return "narrative.linear"
        case .nonlinear: return "narrative.nonlinear"
        case .slowBurn: return "narrative.slow_burn"
        case .twisty: return "narrative.twisty"
        case .contemplative: return "narrative.contemplative"
        }
    }
}

enum PacingPreference: String, CaseIterable, Codable, Identifiable {
    case slow = "Slow"
    case balanced = "Balanced"
    case fast = "Fast"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .slow: return "pacing.slow"
        case .balanced: return "pacing.balanced"
        case .fast: return "pacing.fast"
        }
    }
}

enum ComplexityPreference: String, CaseIterable, Codable, Identifiable {
    case simple = "Simple"
    case medium = "Medium"
    case complex = "Complex"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .simple: return "complexity.simple"
        case .medium: return "complexity.medium"
        case .complex: return "complexity.complex"
        }
    }
}

enum Mood: String, CaseIterable, Codable, Identifiable {
    case feelGood = "Feel Good"
    case dark = "Dark"
    case mindBending = "Mind-Bending"
    case emotional = "Emotional"
    case neutral = "Neutral"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .feelGood: return "mood.feel_good"
        case .dark: return "mood.dark"
        case .mindBending: return "mood.mind_bending"
        case .emotional: return "mood.emotional"
        case .neutral: return "mood.neutral"
        }
    }
}

enum WatchContext: String, CaseIterable, Codable, Identifiable {
    case alone = "Alone"
    case partner = "Partner"
    case friends = "Friends"
    case family = "Family"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .alone: return "context.alone"
        case .partner: return "context.partner"
        case .friends: return "context.friends"
        case .family: return "context.family"
        }
    }
}

enum Language: String, CaseIterable, Codable, Identifiable {
    case english = "English"
    case portuguese = "Portuguese"
    case spanish = "Spanish"
    case french = "French"
    case german = "German"
    case italian = "Italian"
    case japanese = "Japanese"
    case korean = "Korean"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .english: return "language.english"
        case .portuguese: return "language.portuguese"
        case .spanish: return "language.spanish"
        case .french: return "language.french"
        case .german: return "language.german"
        case .italian: return "language.italian"
        case .japanese: return "language.japanese"
        case .korean: return "language.korean"
        }
    }
}

enum GoreSensitivity: String, CaseIterable, Codable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }

    var displayName: String {
        NSLocalizedString(localizationKey, comment: "")
    }

    private var localizationKey: String {
        switch self {
        case .low: return "gore.low"
        case .medium: return "gore.medium"
        case .high: return "gore.high"
        }
    }
}
