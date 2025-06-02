import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        NavigationView {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                WelcomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .navigationTitle("Circuit")
            }
        }
    }
}

#Preview {
    ContentView()
} 
