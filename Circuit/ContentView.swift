import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Circuit")
                    .font(.largeTitle)
                    .padding()
                
                Text("Your fresh start begins here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Circuit")
        }
    }
}

#Preview {
    ContentView()
} 
