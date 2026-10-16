import SwiftUI

public struct FestiveCard<Content: View>: View {
    let highlighted: Bool
    let content: Content
    
    public init(highlighted: Bool = false, @ViewBuilder content: () -> Content) {
        self.highlighted = highlighted
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(Theme.cardSurface.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .stroke(
                                highlighted ? Theme.goldGradient : LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.04)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: highlighted ? 1.5 : 1.0
                            )
                    )
            )
            .shadow(color: highlighted ? Theme.gold.opacity(0.3) : Color.black.opacity(0.35),
                    radius: highlighted ? 12 : 6, x: 0, y: 3)
    }
}
