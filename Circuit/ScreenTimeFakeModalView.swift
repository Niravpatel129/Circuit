import SwiftUI
import FamilyControls

struct ScreenTimeFakeModalView: View {
    var onAuthorized: () -> Void
    @State private var isRequesting = false

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                Spacer()
                // Progress bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(height: 16)
                    .overlay(
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.purple)
                                .frame(width: geo.size.width * 0.3)
                        }
                    )
                    .padding(.horizontal, 40)
                    .padding(.top, 40)

                Spacer()
                Text("First, allow Screentime")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                Text("To limit your distracting apps, ScreenZen requires your permission")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 8)

                Spacer()

                // Fake modal
                VStack(spacing: 0) {
                    Text("ScreenZen Would Like to Access Screen Time")
                        .font(.headline)
                        .padding(.top, 20)
                    Text("Providing ScreenZen access to Screen Time may allow it to see your activity data, restrict content, and limit the usage of apps and websites.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    HStack(spacing: 0) {
                        Button(action: {
                            isRequesting = true
                            Task {
                                do {
                                    try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                                } catch {
                                    // Handle error if needed
                                }
                                isRequesting = false
                                onAuthorized()
                            }
                        }) {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                        }
                        .disabled(isRequesting)
                        Button("Don't Allow") {
                            onAuthorized()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.black)
                    }
                    .padding(.top, 8)
                }
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .shadow(radius: 10)

                // Arrow
                Image(systemName: "arrow.up")
                    .foregroundColor(.purple)
                    .font(.system(size: 30))
                    .padding(.top, 8)

                Spacer()

                Text("Your data is protected by Apple")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                Button("Learn More") {
                    // Open link or show info
                }
                .foregroundColor(.white)
                .padding(.bottom, 30)
            }
        }
    }
} 
