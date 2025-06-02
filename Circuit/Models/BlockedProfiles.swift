import Foundation
import SwiftData
#if canImport(FamilyControls)
import FamilyControls
#endif
#if canImport(ManagedSettings)
import ManagedSettings
#endif

@Model
final class BlockedProfiles {
    // MARK: - Basic Attributes
    @Attribute(.unique) var id: UUID
    var name: String

    #if canImport(FamilyControls)
    /// The set of apps / categories the user has chosen to block.
    var selectedActivity: FamilyActivitySelection
    #else
    // Fallback when `FamilyControls` is not available – keep the field so the
    // model schema stays identical, but use raw Data as placeholder.
    var selectedActivityData: Data?
    #endif

    var createdAt: Date
    var updatedAt: Date

    /// Identifier of the strategy (see `StrategyManager`) used for this profile
    var blockingStrategyId: String?

    // MARK: - Feature Flags
    var enableLiveActivity: Bool = false
    var reminderTimeInSeconds: UInt32?
    var enableBreaks: Bool = false
    var enableStrictMode: Bool = false
    var enableAllowMode: Bool = false

    // MARK: - Relationships
    @Relationship var sessions: [BlockedProfileSession] = []

    // MARK: - Init
    #if canImport(FamilyControls)
    init(
        id: UUID = UUID(),
        name: String,
        selectedActivity: FamilyActivitySelection = FamilyActivitySelection(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        blockingStrategyId: String? = nil,
        enableLiveActivity: Bool = false,
        reminderTimeInSeconds: UInt32? = nil,
        enableBreaks: Bool = false,
        enableStrictMode: Bool = false,
        enableAllowMode: Bool = false
    ) {
        self.id = id
        self.name = name
        self.selectedActivity = selectedActivity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.blockingStrategyId = blockingStrategyId
        self.enableLiveActivity = enableLiveActivity
        self.reminderTimeInSeconds = reminderTimeInSeconds
        self.enableBreaks = enableBreaks
        self.enableStrictMode = enableStrictMode
        self.enableAllowMode = enableAllowMode
    }
    #else
    init(
        id: UUID = UUID(),
        name: String,
        selectedActivityData: Data? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        blockingStrategyId: String? = nil,
        enableLiveActivity: Bool = false,
        reminderTimeInSeconds: UInt32? = nil,
        enableBreaks: Bool = false,
        enableStrictMode: Bool = false,
        enableAllowMode: Bool = false
    ) {
        self.id = id
        self.name = name
        self.selectedActivityData = selectedActivityData
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.blockingStrategyId = blockingStrategyId
        self.enableLiveActivity = enableLiveActivity
        self.reminderTimeInSeconds = reminderTimeInSeconds
        self.enableBreaks = enableBreaks
        self.enableStrictMode = enableStrictMode
        self.enableAllowMode = enableAllowMode
    }
    #endif

    // MARK: - Convenience
    static func getProfileDeepLink(_ profile: BlockedProfiles) -> String {
        "https://circuit.app/profile/" + profile.id.uuidString
    }
}