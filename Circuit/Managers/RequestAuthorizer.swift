import SwiftUI

#if canImport(FamilyControls)
import FamilyControls
#endif
#if canImport(DeviceActivity)
import DeviceActivity
#endif
#if canImport(ManagedSettings)
import ManagedSettings
#endif

/// Wrapper around FamilyControls `AuthorizationCenter` that exposes
/// the authorisation status to SwiftUI views.
final class RequestAuthorizer: ObservableObject {
    @Published var isAuthorized: Bool = false

    /// Requests the Focus/Screen-Time authorisation needed for app blocking.
    /// Falls back to `true` on simulator / macOS where the framework is
    /// unavailable so the rest of the app can continue to run.
    func requestAuthorization() {
        #if canImport(FamilyControls) && !targetEnvironment(macCatalyst)
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                await MainActor.run { self.isAuthorized = true }
            } catch {
                print("[RequestAuthorizer] Authorization failed: \(error)")
                await MainActor.run { self.isAuthorized = false }
            }
        }
        #else
        // Simulator or unsupported platform – assume authorised so the UI works.
        DispatchQueue.main.async {
            self.isAuthorized = true
        }
        #endif
    }
}