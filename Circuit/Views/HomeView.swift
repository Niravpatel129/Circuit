import SwiftUI
import CoreNFC

// --- Environment-managed HomeView that mirrors Foqos dashboard style ---
struct HomeView: View {
    @StateObject private var nfcReader = NFCReader()

    // Managers provided from CircuitApp
    @EnvironmentObject private var strategyManager: StrategyManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var requestAuthorizer: RequestAuthorizer

    // UI State
    @State private var isReadyToScan: Bool = false
    @State private var showQRCode: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Circuit")
                    .font(.largeTitle).bold()
                    .padding(.horizontal, 20)

                // INFO
                InfoCard(
                    icon: "wave.3.right.circle.fill",
                    title: "NFC Status",
                    message: nfcReader.connectionStatus
                )
                .padding(.horizontal, 20)

                // ACTIONS
                VStack(spacing: 12) {
                    ActionCard(
                        icon: isReadyToScan ? "xmark.circle.fill" : "tag.fill",
                        title: isReadyToScan ? "Cancel Scan" : "Scan NFC Tag",
                        color: .blue
                    ) {
                        withAnimation {
                            isReadyToScan.toggle()
                            if isReadyToScan {
                                nfcReader.startScanning()
                            } else {
                                nfcReader.connectionStatus = "Not Connected"
                            }
                        }
                    }

                    ActionCard(
                        icon: strategyManager.isBlocking ? "lock.open.fill" : "lock.fill",
                        title: strategyManager.isBlocking ? "Stop Blocking" : "Start Blocking",
                        color: strategyManager.isBlocking ? .red : .green
                    ) {
                        strategyManager.toggleBlocking()
                    }

                    // QR fallback if NFC is unavailable
                    if !NFCNDEFReaderSession.readingAvailable {
                        ActionCard(
                            icon: "qrcode",
                            title: "Show QR Code",
                            color: .purple
                        ) {
                            showQRCode = true
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Active session info
                if let _ = strategyManager.activeSession {
                    InfoCard(
                        icon: "clock.fill",
                        title: "Session Active",
                        message: "Running for " + formatDuration(strategyManager.elapsedTime)
                    )
                    .padding(.horizontal, 20)
                }

                // Profiles carousel
                BlockedProfileCarousel()
                    .padding(.top, 16)

                Spacer()
            }
            .padding(.top, 32)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showQRCode) {
            QRCodeView(dataString: "https://circuit.app/profile/placeholder", title: "Circuit QR Code")
        }
    }

    private func formatDuration(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval) ?? "0s"
    }
}

#Preview {
    HomeView()
        .environmentObject(StrategyManager())
        .environmentObject(NavigationManager())
        .environmentObject(RequestAuthorizer())
} 
