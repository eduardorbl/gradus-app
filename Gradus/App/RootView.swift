import SwiftUI

struct RootView: View {
    let appContainer: AppContainer
    @AppStorage("app_language") private var appLanguage: AppLanguage = .system

    var body: some View {
        DiscoveryView(appContainer: appContainer)
            .environment(\.locale, appLanguage.locale ?? Locale.current)
    }
}
