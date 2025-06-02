import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding(.top)
                        
                        Text("John Doe")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("john.doe@example.com")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    
                    // Stats Section
                    HStack(spacing: 20) {
                        StatView(value: "12", title: "Tasks")
                        StatView(value: "5", title: "Projects")
                        StatView(value: "3", title: "Teams")
                    }
                    .padding()
                    
                    // Settings List
                    VStack(spacing: 0) {
                        SettingsRow(icon: "person.fill", title: "Edit Profile")
                        SettingsRow(icon: "bell.fill", title: "Notifications")
                        SettingsRow(icon: "lock.fill", title: "Privacy")
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support")
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

struct StatView: View {
    let value: String
    let title: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
} 
