import SwiftUI

/// Placeholder for the richer `StrategyManager` that exists in Foqos.
/// At this stage we only expose the pieces that the UI will compile against.
final class StrategyManager: ObservableObject {
    /// Indicates whether the app-blocking session is currently active.
    @Published var isBlocking: Bool = false

    /// Simple toggle until full strategy logic is ported.
    func toggleBlocking() {
        isBlocking.toggle()
    }
}