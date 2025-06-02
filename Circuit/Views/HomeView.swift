import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome Back!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Here's what's happening today")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 2)
                
                // Quick Actions
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    QuickActionCard(title: "New Task", icon: "plus.circle.fill", color: .blue)
                        .onTapGesture {
                            // Handle task creation
                        }
                    QuickActionCard(title: "Calendar", icon: "calendar", color: .green)
                        .onTapGesture {
                            // Handle calendar navigation
                        }
                    QuickActionCard(title: "Messages", icon: "message.fill", color: .purple)
                        .onTapGesture {
                            // Handle messages navigation
                        }
                    QuickActionCard(title: "Settings", icon: "gear", color: .orange)
                        .onTapGesture {
                            // Handle settings navigation
                        }
                }
            }
            .padding()
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
} 
