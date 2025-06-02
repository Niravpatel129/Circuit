import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var authorizationStatus: AuthorizationStatus = .notDetermined
    
    let pages = [
        OnboardingPage(
            title: "Welcome to Circuit",
            description: "Your personal task management companion",
            imageName: "checkmark.circle.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Keep track of your tasks and never miss a deadline",
            imageName: "list.bullet.clipboard.fill",
            color: .green
        ),
        OnboardingPage(
            title: "Screen Time Access",
            description: "Allow Circuit to help you manage your screen time and stay focused",
            imageName: "clock.fill",
            color: .orange
        ),
        OnboardingPage(
            title: "Get Started",
            description: "Begin your journey to better productivity",
            imageName: "arrow.right.circle.fill",
            color: .purple
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Progress indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? pages[index].color : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .foregroundColor(.primary)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            if currentPage == 2 { // Screen Time permission page
                                Task {
                                    do {
                                        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                                        withAnimation {
                                            currentPage += 1
                                        }
                                    } catch {
                                        print("Failed to request screen time authorization: \(error)")
                                    }
                                }
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } else {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .foregroundColor(.white)
                            .padding()
                            .background(pages[currentPage].color)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .font(.system(size: 100))
                .foregroundColor(page.color)
                .padding(.top, 60)
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
} 
