import Foundation
import SwiftUI

public enum CardDesignTheme: String, CaseIterable, Identifiable, Codable {
    case goldenOrnament = "Golden Ornament"
    case snowyPine = "Snowy Pine"
    case velvetRoyalty = "Velvet Ribbon"
    case vintagePostage = "Vintage Postcard"
    case modernFrost = "Modern Frost"
    case midnightMagic = "Midnight Starlight"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .goldenOrnament: return "sparkles"
        case .snowyPine: return "tree.fill"
        case .velvetRoyalty: return "gift.fill"
        case .vintagePostage: return "envelope.fill"
        case .modernFrost: return "snowflake"
        case .midnightMagic: return "moon.stars.fill"
        }
    }
}

public enum CardTextPlacement: String, CaseIterable, Identifiable, Codable {
    case bottomBanner = "Bottom Banner"
    case topAndBottom = "Top & Bottom"
    case overlayCentered = "Overlay Center"
    case vintageBorder = "Framed Card"
    
    public var id: String { rawValue }
}

public enum CardFontStyle: String, CaseIterable, Identifiable, Codable {
    case elegantSerif = "Classic Holiday"
    case festiveScript = "Merry Script"
    case modernSans = "Modern Chic"
    case playfulWinter = "Winter Warmth"
    
    public var id: String { rawValue }
    
    public func font(size: CGFloat) -> Font {
        switch self {
        case .elegantSerif:
            return .system(size: size, weight: .bold, design: .serif)
        case .festiveScript:
            return .system(size: size, weight: .bold, design: .serif).italic()
        case .modernSans:
            return .system(size: size, weight: .heavy, design: .rounded)
        case .playfulWinter:
            return .system(size: size, weight: .semibold, design: .rounded)
        }
    }
}

public struct GreetingCardConfig: Codable, Equatable {
    public var designTheme: CardDesignTheme
    public var headline: String
    public var subheadline: String
    public var recipientOrFamilyName: String
    public var yearLabel: String
    public var textPlacement: CardTextPlacement
    public var fontStyle: CardFontStyle
    public var headlineFontSize: CGFloat
    public var showFestiveBorder: Bool
    public var showGoldFoilAccent: Bool
    
    public init(
        designTheme: CardDesignTheme = .goldenOrnament,
        headline: String = "Merry Christmas",
        subheadline: String = "May your days be merry & bright",
        recipientOrFamilyName: String = "With Love from Our Family",
        yearLabel: String = "Holiday 2026",
        textPlacement: CardTextPlacement = .bottomBanner,
        fontStyle: CardFontStyle = .elegantSerif,
        headlineFontSize: CGFloat = 28,
        showFestiveBorder: Bool = true,
        showGoldFoilAccent: Bool = true
    ) {
        self.designTheme = designTheme
        self.headline = headline
        self.subheadline = subheadline
        self.recipientOrFamilyName = recipientOrFamilyName
        self.yearLabel = yearLabel
        self.textPlacement = textPlacement
        self.fontStyle = fontStyle
        self.headlineFontSize = headlineFontSize
        self.showFestiveBorder = showFestiveBorder
        self.showGoldFoilAccent = showGoldFoilAccent
    }
}
