import SwiftUI

struct ProfileTimerButton: View {
    var isActive: Bool
    var elapsedTime: TimeInterval?
    var action: () -> Void

    private var title: String {
        if isActive {
            return "Stop"
        } else {
            return "Start"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if isActive, let elapsed = elapsedTime {
                    Text(formatDuration(elapsed))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(isActive ? Color.red : Color.green)
                    .cornerRadius(16)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func formatDuration(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval) ?? "0m"
    }
}

#Preview {
    VStack(spacing: 12) {
        ProfileTimerButton(isActive: false, elapsedTime: nil) {}
        ProfileTimerButton(isActive: true, elapsedTime: 1250) {}
    }
    .padding()
}