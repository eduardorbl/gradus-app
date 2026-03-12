import SwiftUI

struct RootView: View {
    let appContainer: AppContainer

    var body: some View {
        DiscoveryView(appContainer: appContainer)
    }
}
