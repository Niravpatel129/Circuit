import Foundation
import CoreNFC
import SwiftUI

/// Handles scanning NFC NDEF tags and publishing status updates
/// so SwiftUI views can react. Extracted from the original `HomeView`.
final class NFCReader: NSObject, ObservableObject {
    // MARK: - Published properties
    @Published var isScanning = false
    @Published var connectionStatus: String = "Not Connected"

    private var session: NFCNDEFReaderSession?

    // MARK: - Public API
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
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NFCReader: NFCNDEFReaderSessionDelegate {
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