import SwiftUI

/// Placeholder for the richer `StrategyManager` that exists in Foqos.
/// At this stage we only expose the pieces that the UI will compile against.
final class StrategyManager: ObservableObject {
    // MARK: - Session state
    @Published var activeSession: BlockedProfileSession?
    @Published var elapsedTime: TimeInterval = 0

    private var timer: Timer?
    private let timersUtil = TimersUtil()
    private let liveActivityManager = LiveActivityManager.shared

    var isBlocking: Bool { activeSession != nil }

    // MARK: - Public API
    func toggleBlocking() {
        if isBlocking {
            stopBlocking()
        } else {
            startBlocking()
        }
    }

    func loadActiveSession(context: ModelContext? = nil) {
        // In a complete implementation we would query SwiftData for an active session.
        // For now we rely on in-memory state.
    }

    // MARK: - Private helpers
    private func startBlocking() {
        // Create a dummy profile/session until full profiles UI arrives.
        let dummyProfile = BlockedProfiles(name: "Focus")
        activeSession = BlockedProfileSession(tag: "manual", blockedProfile: dummyProfile)

        // Schedule a reminder notification after 30 minutes.
        _ = timersUtil.scheduleNotification(title: "Break over", message: "Time to get back to work", seconds: 60 * 30)

        startTimer()
        liveActivityManager.startSessionActivity(session: activeSession!)
    }

    private func stopBlocking() {
        guard let session = activeSession else { return }
        session.endSession()

        liveActivityManager.endSessionActivity()
        stopTimer()
        activeSession = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self, let start = self.activeSession?.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(start)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }
}