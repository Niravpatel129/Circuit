import SwiftUI
import SwiftData

@main
struct CircuitApp: App {
    // MARK: - StateObjects used across the entire app
    @StateObject private var requestAuthorizer = RequestAuthorizer()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var strategyManager = StrategyManager()
    @StateObject private var nfcWriter = NFCWriter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Handle universal links & deep-links
                .onOpenURL { url in
                    navigationManager.handleLink(url)
                }
                // Inject shared managers
                .environmentObject(requestAuthorizer)
                .environmentObject(navigationManager)
                .environmentObject(strategyManager)
                .environmentObject(nfcWriter)
        }
        // Register SwiftData models used across the app
        .modelContainer(for: [BlockedProfileSession.self, BlockedProfiles.self])
    }
} 
