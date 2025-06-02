import SwiftUI

struct WelcomeView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack {
            Text("Welcome to Circuit")
                .font(.largeTitle)
                .padding()
            
            Text("Your fresh start begins here")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            NavigationLink(destination: OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView {
        WelcomeView(hasCompletedOnboarding: .constant(false))
    }
} 
