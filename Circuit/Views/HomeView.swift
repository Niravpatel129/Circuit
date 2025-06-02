import SwiftUI

struct HomeView: View {
    @State private var isReadyToScan = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Tag Image
            Image(systemName: "tag.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding()
            
            // Lock Button
            Button(action: {
                withAnimation {
                    isReadyToScan.toggle()
                }
            }) {
                Text(isReadyToScan ? "Ready to Scan" : "Tap to Lock Circuit")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isReadyToScan ? Color.green : Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
} 
