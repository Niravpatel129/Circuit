import Foundation
import SwiftUI

#if canImport(ActivityKit)
import ActivityKit
#endif

// Simplified Live Activity manager. Provides no-op implementations on
// platforms where ActivityKit is unavailable.
final class LiveActivityManager: ObservableObject {
    static let shared = LiveActivityManager()
    private init() {}

    #if canImport(ActivityKit)
    @Published var currentActivity: Activity<DynamicIslandAttributes>?
    
    struct DynamicIslandAttributes: ActivityAttributes {
        public struct ContentState: Codable, Hashable {
            var startTime: Date
        }
        var name: String
    }
    #endif

    func startSessionActivity(session: BlockedProfileSession) {
        #if canImport(ActivityKit)
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        if currentActivity != nil { return }
        let attributes = DynamicIslandAttributes(name: session.blockedProfile.name)
        let contentState = DynamicIslandAttributes.ContentState(startTime: session.startTime)
        do {
            currentActivity = try Activity.request(attributes: attributes, contentState: contentState)
        } catch {
            print("LiveActivity error: \(error)")
        }
        #endif
    }

    func updateSessionActivity(session: BlockedProfileSession) {
        #if canImport(ActivityKit)
        guard let activity = currentActivity else { return }
        let updated = DynamicIslandAttributes.ContentState(startTime: session.startTime)
        Task { await activity.update(using: updated) }
        #endif
    }

    func endSessionActivity() {
        #if canImport(ActivityKit)
        guard let activity = currentActivity else { return }
        Task { await activity.end(dismissalPolicy: .immediate) }
        currentActivity = nil
        #endif
    }
}