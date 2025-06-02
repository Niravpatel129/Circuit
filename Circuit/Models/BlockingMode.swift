import Foundation
import FamilyControls

struct BlockingMode: Identifiable, Codable {
    let id: UUID
    var name: String
    var blockedApps: Set<String> // Store app IDs as strings
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String, blockedApps: Set<String> = [], isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.blockedApps = blockedApps
        self.isDefault = isDefault
    }
    
    static let defaultModes: [BlockingMode] = [
        BlockingMode(name: "Default", isDefault: true),
        BlockingMode(name: "Gym", blockedApps: []),
        BlockingMode(name: "Work", blockedApps: []),
        BlockingMode(name: "Study", blockedApps: [])
    ]
} 
