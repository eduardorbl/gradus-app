import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case englishUS
    case portugueseBR

    var id: String { rawValue }

    var locale: Locale? {
        switch self {
        case .system:
            return nil
        case .englishUS:
            return Locale(identifier: "en_US")
        case .portugueseBR:
            return Locale(identifier: "pt_BR")
        }
    }

    var displayName: String {
        switch self {
        case .system:
            return String(localized: "language.system")
        case .englishUS:
            return String(localized: "language.english_us")
        case .portugueseBR:
            return String(localized: "language.portuguese_br")
        }
    }
}
