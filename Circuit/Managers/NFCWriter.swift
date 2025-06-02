import CoreNFC
import SwiftUI

/// Lightweight representation of a scanned NFC payload.
struct NFCResult: Equatable {
    var id: String
    var url: String?
    var dateScanned: Date
}

/// Provides NFC tag writing functionality similar to Foqos but trimmed to the
/// essentials so Circuit can compile immediately.
final class NFCWriter: NSObject, ObservableObject {
    @Published var isScanning: Bool = false
    @Published var errorMessage: String? = nil

    private var nfcSession: NFCReaderSession?
    private var urlToWrite: String?

    /// Attempts to write the supplied URL onto an NFC tag.
    func writeURL(_ url: String) {
        guard NFCReaderSession.readingAvailable else {
            errorMessage = "NFC writing not available on this device"
            return
        }
        guard URL(string: url) != nil else {
            errorMessage = "Invalid URL format"
            return
        }

        urlToWrite = url
        let ndefSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        ndefSession.alertMessage = "Hold your iPhone near an NFC tag to write the URL."
        ndefSession.begin()
        isScanning = true
    }
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NFCWriter: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Not required for writing.
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "No tag found")
            return
        }

        session.connect(to: tag) { [weak self] error in
            guard let self else { return }
            if let error = error {
                session.invalidate(errorMessage: "Connection error: \(error.localizedDescription)")
                return
            }

            tag.queryNDEFStatus { status, _, error in
                if let error = error {
                    session.invalidate(errorMessage: "Failed to query tag: \(error.localizedDescription)")
                    return
                }

                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Tag is not NDEF compliant")
                case .readOnly:
                    session.invalidate(errorMessage: "Tag is read-only")
                case .readWrite:
                    self.handleReadWrite(session: session, tag: tag)
                @unknown default:
                    session.invalidate(errorMessage: "Unknown tag status")
                }
            }
        }
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) { }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.isScanning = false
            if let readerError = error as? NFCReaderError, readerError.code == .readerSessionInvalidationErrorUserCanceled {
                // User cancelled – don't surface as error.
                return
            }
            self.errorMessage = error.localizedDescription
        }
    }

    private func handleReadWrite(session: NFCNDEFReaderSession, tag: NFCNDEFTag) {
        guard let urlString = urlToWrite, let url = URL(string: urlString), let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            session.invalidate(errorMessage: "Invalid URL")
            return
        }
        let message = NFCNDEFMessage(records: [payload])
        tag.writeNDEF(message) { error in
            if let error = error {
                session.invalidate(errorMessage: "Write failed: \(error.localizedDescription)")
            } else {
                session.alertMessage = "Successfully wrote URL to tag"
                session.invalidate()
            }
        }
    }
}