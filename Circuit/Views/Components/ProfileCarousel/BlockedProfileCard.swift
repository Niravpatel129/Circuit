import SwiftUI

struct BlockedProfileCard: View {
    let profile: BlockedProfiles
    let isActive: Bool
    let elapsedTime: TimeInterval?
    let onToggle: () -> Void
    let onEdit: () -> Void

    private var background: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color(UIColor.secondarySystemBackground))
    }

    var body: some View {
        ZStack {
            background
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(profile.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(6)
                            .background(Circle().fill(Color(UIColor.tertiarySystemBackground)))
                    }
                }

                ProfileIndicators(
                    enableLiveActivity: profile.enableLiveActivity,
                    hasReminders: profile.reminderTimeInSeconds != nil,
                    enableBreaks: profile.enableBreaks
                )

                Spacer()

                ProfileTimerButton(isActive: isActive, elapsedTime: elapsedTime) {
                    onToggle()
                }
            }
            .padding(20)
        }
        .frame(height: 220)
    }
}

#Preview {
    let profile = BlockedProfiles(name: "Work")
    return VStack {
        BlockedProfileCard(profile: profile, isActive: false, elapsedTime: nil, onToggle: {}, onEdit: {})
        BlockedProfileCard(profile: profile, isActive: true, elapsedTime: 600, onToggle: {}, onEdit: {})
    }
    .padding()
}