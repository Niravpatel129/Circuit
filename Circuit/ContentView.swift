import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    @State private var hasRequestedScreenTime = false
    @State private var hasPickedApps = false
    @State private var hasSyncedDevice = false
    @State private var pickedApps: [String] = []

    var body: some View {
        NavigationView {
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .navigationTitle("Circuit")
            } else if !hasRequestedScreenTime {
                ScreenTimeFakeModalView {
                    hasRequestedScreenTime = true
                }
            } else if !hasPickedApps {
                AppPickerView { apps in
                    pickedApps = apps
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
