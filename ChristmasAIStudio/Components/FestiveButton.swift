import SwiftUI

public enum FestiveButtonStyle {
    case gold
    case velvetRed
    case glass
    case subtle
}

public struct FestiveButton: View {
    let title: String
    let systemImage: String?
    let style: FestiveButtonStyle
    let isLoading: Bool
    let action: () -> Void
    
    public init(
        _ title: String,
        systemImage: String? = nil,
        style: FestiveButtonStyle = .gold,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(style == .gold ? .black : .white)
                } else {
                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(Theme.holidayHeadline(size: 17))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(borderColor, lineWidth: 1.0)
            )
            .shadow(color: shadowColor, radius: 10, x: 0, y: 4)
        }
        .disabled(isLoading)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .gold:
            Theme.goldGradient
        case .velvetRed:
            Theme.velvetGradient
        case .glass:
            Color.white.opacity(0.12)
        case .subtle:
            Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .gold:
            return Color(red: 0.15, green: 0.10, blue: 0.05)
        case .velvetRed:
            return Theme.snowWhite
        case .glass:
            return Theme.snowWhite
        case .subtle:
            return Theme.champagneGold
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .gold:
            return Theme.champagneGold.opacity(0.8)
        case .velvetRed:
            return Theme.brightBerry.opacity(0.6)
        case .glass:
            return Color.white.opacity(0.2)
        case .subtle:
            return Theme.gold.opacity(0.4)
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .gold:
            return Theme.gold.opacity(0.35)
        case .velvetRed:
            return Theme.christmasRed.opacity(0.4)
        case .glass:
            return Color.black.opacity(0.2)
        case .subtle:
            return Color.clear
        }
    }
}
