import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct CircuitApp: App {
    // MARK: - StateObjects used across the entire app
    @StateObject private var requestAuthorizer = RequestAuthorizer()
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var strategyManager = StrategyManager()
    @StateObject private var nfcWriter = NFCWriter()
    @StateObject private var liveActivityManager = LiveActivityManager.shared

    init() {
        // Register background tasks when the app launches
        TimersUtil.registerBackgroundTasks()
    }

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
                .environmentObject(liveActivityManager)
        }
        // Register SwiftData models used across the app
        .modelContainer(for: [BlockedProfileSession.self, BlockedProfiles.self])
    }
} 
