import SwiftUI

/// Christmas AI Studio Design System & Theme
/// Elegant US Holiday 2026 aesthetic featuring Forest Green, Christmas Velvet Red,
/// Warm Cream, and Antique Gold with adaptive Dark Mode support.
public enum Theme {
    // MARK: - Core Festive Palette
    public static let forestGreen = Color(red: 0.09, green: 0.26, blue: 0.18)
    public static let pineNeedle = Color(red: 0.05, green: 0.17, blue: 0.11)
    public static let lightPine = Color(red: 0.14, green: 0.38, blue: 0.26)
    
    public static let christmasRed = Color(red: 0.78, green: 0.12, blue: 0.18)
    public static let velvetCrimson = Color(red: 0.55, green: 0.08, blue: 0.12)
    public static let brightBerry = Color(red: 0.90, green: 0.20, blue: 0.25)
    
    public static let gold = Color(red: 0.90, green: 0.75, blue: 0.38)
    public static let deepGold = Color(red: 0.78, green: 0.60, blue: 0.24)
    public static let champagneGold = Color(red: 0.96, green: 0.88, blue: 0.65)
    
    public static let warmCream = Color(red: 0.98, green: 0.96, blue: 0.91)
    public static let parchment = Color(red: 0.93, green: 0.90, blue: 0.83)
    public static let snowWhite = Color(red: 0.99, green: 0.99, blue: 1.0)
    
    public static let charcoalBlack = Color(red: 0.08, green: 0.09, blue: 0.11)
    public static let darkSurface = Color(red: 0.12, green: 0.14, blue: 0.17)
    public static let cardSurface = Color(red: 0.16, green: 0.18, blue: 0.22)
    
    // MARK: - Gradients
    public static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [champagneGold, gold, deepGold],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var velvetGradient: LinearGradient {
        LinearGradient(
            colors: [brightBerry, christmasRed, velvetCrimson],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var pineGradient: LinearGradient {
        LinearGradient(
            colors: [lightPine, forestGreen, pineNeedle],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var holidayBackgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.07, green: 0.14, blue: 0.11),
                Color(red: 0.05, green: 0.08, blue: 0.09),
                Color(red: 0.12, green: 0.06, blue: 0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public static var cardGlassGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.12),
                Color.white.opacity(0.04)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography Presets
    public static func holidayTitle(size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }
    
    public static func holidayHeadline(size: CGFloat = 20) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
    
    public static func holidaySubheadline(size: CGFloat = 16) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    
    public static func holidayBody(size: CGFloat = 15) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    public static func holidayScript(size: CGFloat = 24) -> Font {
        .system(size: size, weight: .bold, design: .serif).italic()
    }
    
    // MARK: - Radii & Layout Spacing
    public static let cornerRadiusSmall: CGFloat = 10
    public static let cornerRadiusMedium: CGFloat = 16
    public static let cornerRadiusLarge: CGFloat = 24
    public static let cornerRadiusPill: CGFloat = 999
}

// MARK: - View Modifiers for Theme Styling
public struct FestiveCardModifier: ViewModifier {
    var isHighlighted: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(Theme.cardSurface.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                            .stroke(
                                isHighlighted ? Theme.goldGradient : LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isHighlighted ? 1.5 : 1.0
                            )
                    )
            )
            .shadow(color: isHighlighted ? Theme.gold.opacity(0.25) : Color.black.opacity(0.35),
                    radius: isHighlighted ? 12 : 8, x: 0, y: 4)
    }
}

public extension View {
    func festiveCardStyle(highlighted: Bool = false) -> some View {
        modifier(FestiveCardModifier(isHighlighted: highlighted))
    }
}
