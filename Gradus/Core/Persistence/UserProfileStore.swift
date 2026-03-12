import Foundation

protocol UserProfileStore {
    func load() -> UserProfile
    func save(_ profile: UserProfile)
    func reset()
}

final class FileUserProfileStore: UserProfileStore {
    private let fileURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(fileName: String = "user_profile.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        self.fileURL = (directory ?? URL(fileURLWithPath: NSTemporaryDirectory()))
            .appendingPathComponent(fileName)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }

    func load() -> UserProfile {
        guard let data = try? Data(contentsOf: fileURL) else {
            return .mock
        }
        return (try? decoder.decode(UserProfile.self, from: data)) ?? .mock
    }

    func save(_ profile: UserProfile) {
        guard let data = try? encoder.encode(profile) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    func reset() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
