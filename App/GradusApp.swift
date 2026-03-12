import SwiftUI

@main
struct GradusApp: App {
    private let appContainer = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView(appContainer: appContainer)
        }
    }
}
