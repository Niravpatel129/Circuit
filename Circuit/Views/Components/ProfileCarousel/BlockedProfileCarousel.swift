import SwiftUI
import SwiftData

struct BlockedProfileCarousel: View {
    // Fetch profiles from SwiftData
    @Query(sort: \BlockedProfiles.createdAt, order: .reverse) private var profiles: [BlockedProfiles]

    @EnvironmentObject private var strategyManager: StrategyManager

    // Callbacks
    var onEditTapped: (BlockedProfiles) -> Void = { _ in }

    // Carousel state
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0

    private let cardSpacing: CGFloat = 12
    private let dragThreshold: CGFloat = 40

    var body: some View {
        if profiles.isEmpty {
            EmptyView() // Could show onboarding later
        } else {
            VStack(alignment: .leading, spacing: 12) {
                Text("Profiles")
                    .font(.title2).bold()
                    .padding(.horizontal, 20)

                GeometryReader { geometry in
                    let cardWidth = geometry.size.width - 40 // accounts for side padding
                    HStack(spacing: cardSpacing) {
                        ForEach(profiles.indices, id: \._self) { index in
                            let profile = profiles[index]
                            BlockedProfileCard(
                                profile: profile,
                                isActive: profile.id == strategyManager.activeSession?.blockedProfile.id,
                                elapsedTime: strategyManager.elapsedTime,
                                onToggle: {
                                    // Toggle via StrategyManager
                                    strategyManager.toggleBlocking()
                                },
                                onEdit: {
                                    onEditTapped(profile)
                                }
                            )
                            .frame(width: cardWidth)
                        }
                    }
                    .offset(x: calculateOffset(cardWidth: cardWidth) )
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentIndex)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let translation = value.translation.width
                                if translation < -dragThreshold && currentIndex < profiles.count - 1 {
                                    currentIndex += 1
                                } else if translation > dragThreshold && currentIndex > 0 {
                                    currentIndex -= 1
                                }
                                dragOffset = 0
                            }
                    )
                }
                .frame(height: 240)

                // Dots indicator
                if profiles.count > 1 {
                    HStack(spacing: 6) {
                        ForEach(profiles.indices, id: \._self) { idx in
                            Circle()
                                .fill(idx == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear {
                if let activeId = strategyManager.activeSession?.blockedProfile.id,
                   let idx = profiles.firstIndex(where: { $0.id == activeId }) {
                    currentIndex = idx
                }
            }
        }
    }

    private func calculateOffset(cardWidth: CGFloat) -> CGFloat {
        let totalWidth = cardWidth + cardSpacing
        return CGFloat(currentIndex) * -totalWidth + dragOffset + 20 // 20 = leading padding
    }
}

#Preview {
    BlockedProfileCarousel()
        .environmentObject(StrategyManager())
        .modelContainer(for: BlockedProfiles.self)
}