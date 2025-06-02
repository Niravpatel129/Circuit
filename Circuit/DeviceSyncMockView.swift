import SwiftUI
import CoreNFC

struct DeviceSyncMockView: View {
    @StateObject private var nfcReader = NFCReader()
    @StateObject private var nftService = NFTService()
    @State private var scanned = false
    @State private var isVerifying = false
    @State private var errorMessage: String?
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text("Sync Your Physical Device")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            if !scanned {
                Text("To finish setup, scan your Circuit device by tapping the button below.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal, 30)
                }
                
                Button(action: {
                    errorMessage = nil
                    nfcReader.startScanning()
                }) {
                    HStack {
                        Image(systemName: "radiowaves.left")
                        Text("Scan Tag")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .disabled(nfcReader.isScanning || isVerifying)
                
                if nfcReader.isScanning {
                    Text("Hold your iPhone near the NFC tag")
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                
                if isVerifying {
                    ProgressView("Verifying NFT ownership...")
                        .padding(.top)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                Text("Device synced successfully!")
                    .font(.headline)
                    .foregroundColor(.green)
                Button(action: {
                    onContinue()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .onChange(of: nfcReader.connectionStatus) { status in
            if status.contains("Tag Content:") {
                let nfcPayload = status.replacingOccurrences(of: "Tag Content: ", with: "")
                Task {
                    isVerifying = true
                    do {
                        let isValid = try await nftService.verifyNFTOwnership(nfcPayload: nfcPayload)
                        if isValid {
                            scanned = true
                        } else {
                            errorMessage = "Invalid NFT ownership"
                        }
                    } catch {
                        errorMessage = "Verification failed: \(error.localizedDescription)"
                    }
                    isVerifying = false
                }
            } else if status.contains("Connection Error:") {
                errorMessage = status.replacingOccurrences(of: "Connection Error: ", with: "")
            }
        }
    }
} 
