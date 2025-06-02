import SwiftUI

struct DeviceSyncMockView: View {
    @State private var scanned = false
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
                Button(action: {
                    scanned = true
                }) {
                    Text("Scan Tag")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
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
    }
} 
