import SwiftUI

public struct StyleCardView: View {
    let style: ChristmasStyle
    let isSelected: Bool
    let onSelect: () -> Void
    
    public init(style: ChristmasStyle, isSelected: Bool = false, onSelect: @escaping () -> Void) {
        self.style = style
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 10) {
                // Top Icon / Visual Box
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Theme.lightPine.opacity(0.8),
                                    Theme.pineNeedle.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 120)
                        .overlay(
                            VStack {
                                Image(systemName: style.systemIcon)
                                    .font(.system(size: 38, weight: .light))
                                    .foregroundStyle(Theme.goldGradient)
                                    .shadow(color: Theme.gold.opacity(0.4), radius: 6)
                                
                                Text(style.category.rawValue.uppercased())
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Theme.champagneGold.opacity(0.8))
                                    .tracking(1.2)
                                    .padding(.top, 4)
                            }
                        )
                    
                    // Tag Badge
                    if style.isPopular || style.isNew {
                        Text(style.isNew ? "NEW" : style.tag.uppercased())
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(style.isNew ? Theme.forestGreen : Theme.velvetCrimson)
                            .cornerRadius(6)
                            .padding(8)
                    }
                }
                
                // Style Information
                VStack(alignment: .leading, spacing: 4) {
                    Text(style.name)
                        .font(Theme.holidayHeadline(size: 16))
                        .foregroundColor(Theme.snowWhite)
                        .lineLimit(1)
                    
                    Text(style.description)
                        .font(Theme.holidayBody(size: 12))
                        .foregroundColor(Theme.parchment.opacity(0.75))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 6)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                    .fill(Theme.cardSurface.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                            .stroke(
                                isSelected ? Theme.goldGradient : LinearGradient(
                                    colors: [Color.white.opacity(0.12), Color.white.opacity(0.02)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(color: isSelected ? Theme.gold.opacity(0.35) : Color.black.opacity(0.3),
                    radius: isSelected ? 10 : 4, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
