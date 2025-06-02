import SwiftUI

struct ProfileIndicators: View {
    var enableLiveActivity: Bool
    var hasReminders: Bool
    var enableBreaks: Bool

    var body: some View {
        HStack(spacing: 6) {
            if enableLiveActivity {
                Image(systemName: "waveform.badge.plus")
                    .foregroundColor(.accentColor)
            }
            if hasReminders {
                Image(systemName: "bell.badge")
                    .foregroundColor(.orange)
            }
            if enableBreaks {
                Image(systemName: "cup.and.saucer")
                    .foregroundColor(.green)
            }
        }
        .font(.caption)
    }
}

#Preview {
    ProfileIndicators(enableLiveActivity: true, hasReminders: true, enableBreaks: false)
}