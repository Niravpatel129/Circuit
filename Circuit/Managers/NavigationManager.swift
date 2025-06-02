import SwiftUI

/// A centralised navigation router that understands Universal Links.
/// It publishes the currently-active deep-link so interested views can
/// react and present the appropriate destination.
final class NavigationManager: ObservableObject {
    /// The identifier extracted from the incoming path (e.g. "profile/123")
    @Published var profileId: String? = nil

    /// The raw URL that was opened. Useful for passing through to downstream APIs.
    @Published var link: URL? = nil

    /// Parses an incoming Universal Link and updates published state.
    /// Currently recognises:
    ///   – https://<domain>/profile/<uuid>
    /// Extend this method as new routes are added.
    func handleLink(_ url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let path = components?.path else { return }

        let parts = path.split(separator: "/")
        if let basePath = parts[safe: 0], let profileId = parts[safe: 1] {
            switch String(basePath) {
            case "profile":
                self.profileId = String(profileId)
                self.link = url
            default:
                break
            }
        }
    }

    /// Resets any pending navigation so the UI can return to its idle state.
    func clearNavigation() {
        profileId = nil
        link = nil
    }
}

// MARK: - Collection safe-subscript helper
private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}