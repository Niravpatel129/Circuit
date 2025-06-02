import SwiftUI
import UIKit

struct QRCodeView: View {
    @Environment(\.dismiss) private var dismiss

    let dataString: String
    let title: String

    @State private var qrImage: UIImage? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text(title)
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)

                if let qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 240)
                } else {
                    ProgressView()
                        .frame(width: 240, height: 240)
                }

                Text("Scan this code to trigger focus mode if NFC is unavailable.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                if let qrImage {
                    ShareLink(item: Image(uiImage: qrImage)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear { qrImage = QRGenerator.generate(from: dataString) }
        }
    }
}

#Preview {
    QRCodeView(dataString: "https://circuit.app/profile/demo", title: "Circuit QR")
}