import SwiftUI
import CoreNFC

struct HomeView: View {
    @StateObject private var nfcReader = NFCReader()
    @State private var isReadyToScan = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Tag Image
            Image(systemName: "tag.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
                .padding()
            
            // Connection Status
            Text(nfcReader.connectionStatus)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            // Lock Button
            Button(action: {
                withAnimation {
                    isReadyToScan.toggle()
                    if isReadyToScan {
                        nfcReader.startScanning()
                    } else {
                        nfcReader.connectionStatus = "Not Connected"
                    }
                }
            }) {
                Text(isReadyToScan ? "Ready to Scan" : "Tap to Block Now")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isReadyToScan ? Color.green : Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            
            if nfcReader.isScanning {
                ProgressView()
                    .padding(.top)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
} 
