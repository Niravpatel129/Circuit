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
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.top, 32)
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView()
        .environmentObject(StrategyManager())
        .environmentObject(NavigationManager())
        .environmentObject(RequestAuthorizer())
} 
