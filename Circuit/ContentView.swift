import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    @State private var hasRequestedScreenTime = false
    @State private var hasPickedApps = false
    @State private var hasSyncedDevice = false
    @State private var selectedMode: BlockingMode?

    var body: some View {
        NavigationView {
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if !hasRequestedScreenTime {
                ScreenTimeFakeModalView {
                    hasRequestedScreenTime = true
                }
            } else if !hasPickedApps {
                ModePickerView { mode in
                    selectedMode = mode
                    hasPickedApps = true
                }
            } else if !hasSyncedDevice {
                DeviceSyncMockView {
                    hasSyncedDevice = true
                }
            } else {
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
} 
