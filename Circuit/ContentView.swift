import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        NavigationView {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                WelcomeView()
                    .navigationTitle("Circuit")
            }
        }
    }
}

#Preview {
    ContentView()
} 
