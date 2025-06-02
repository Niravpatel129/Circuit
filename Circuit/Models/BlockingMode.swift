import Foundation

struct BlockingMode: Identifiable, Codable {
    let id: UUID
    var name: String
    var blockedApps: Set<String>
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String, blockedApps: Set<String> = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.blockedApps = blockedApps
        self.isDefault = isDefault
    }
    
    static let defaultModes: [BlockingMode] = [
        BlockingMode(name: "Default", isDefault: true),
        BlockingMode(name: "Gym", blockedApps: ["Instagram", "TikTok", "YouTube"]),
        BlockingMode(name: "Work", blockedApps: ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter", "Facebook"]),
        BlockingMode(name: "Study", blockedApps: ["Instagram", "TikTok", "YouTube", "Snapchat", "Twitter", "Facebook", "Games"])
    ]
} 
