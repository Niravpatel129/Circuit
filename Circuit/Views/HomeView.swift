import SwiftUI
import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var isScanning = false
    @Published var connectionStatus: String = "Not Connected"
    var session: NFCNDEFReaderSession?
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            connectionStatus = "NFC not available on this device"
            print("NFC not available on this device")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the NFC tag"
        session?.begin()
        isScanning = true
        connectionStatus = "Scanning..."
        print("NFC scanning started")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        isScanning = false
        connectionStatus = "Connection Error: \(error.localizedDescription)"
        print("NFC Session invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        connectionStatus = "Tag Detected!"
        print("NFC Tag detected")
        
        for message in messages {
            for record in message.records {
                if let payload = String(data: record.payload, encoding: .utf8) {
                    print("NFC Tag Content: \(payload)")
                    connectionStatus = "Tag Content: \(payload)"
                }
            }
        }
        
        // End the session after successful read
        session.invalidate()
        isScanning = false
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("NFC Session became active")
        connectionStatus = "Ready to scan"
    }
}

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
