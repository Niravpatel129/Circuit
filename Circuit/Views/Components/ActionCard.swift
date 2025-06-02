import SwiftUI

/// A tappable card that displays an icon and label.
/// Mirrors the style used in Foqos' ManageSection for quick actions.
struct ActionCard: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 12) {
        ActionCard(icon: "lock.fill", title: "Block Now", color: .blue) {}
        ActionCard(icon: "gearshape.fill", title: "Settings", color: .gray) {}
    }
    .padding()
}