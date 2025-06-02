import Foundation
import SwiftData

@Model
final class BlockedProfileSession {
    // MARK: - Attributes
    @Attribute(.unique) var id: String
    var tag: String

    @Relationship var blockedProfile: BlockedProfiles

    var startTime: Date
    var endTime: Date?

    // Break support
    var breakStartTime: Date?
    var breakEndTime: Date?

    // MARK: - Computed properties
    var isActive: Bool { endTime == nil }

    var isBreakAvailable: Bool {
        blockedProfile.enableBreaks && breakEndTime == nil
    }

    var isBreakActive: Bool {
        blockedProfile.enableBreaks && breakStartTime != nil && breakEndTime == nil
    }

    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }

    // MARK: - Init
    init(tag: String, blockedProfile: BlockedProfiles) {
        self.id = UUID().uuidString
        self.tag = tag
        self.blockedProfile = blockedProfile
        self.startTime = Date()

        // Append to parent relationship.
        blockedProfile.sessions.append(self)
    }

    // MARK: - Lifecycle helpers
    func startBreak() { breakStartTime = Date() }
    func endBreak() { breakEndTime = Date() }
    func endSession() { endTime = Date() }

    // MARK: - Static helpers
    static func mostRecentActiveSession(in context: ModelContext) -> BlockedProfileSession? {
        var descriptor = FetchDescriptor<BlockedProfileSession>(
            predicate: #Predicate { $0.endTime == nil },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    static func createSession(in context: ModelContext, tag: String, profile: BlockedProfiles) -> BlockedProfileSession {
        let session = BlockedProfileSession(tag: tag, blockedProfile: profile)
        context.insert(session)
        return session
    }

    static func recentInactiveSessions(in context: ModelContext, limit: Int = 50) -> [BlockedProfileSession] {
        var descriptor = FetchDescriptor<BlockedProfileSession>(
            predicate: #Predicate { $0.endTime != nil },
            sortBy: [SortDescriptor(\.endTime, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }
}