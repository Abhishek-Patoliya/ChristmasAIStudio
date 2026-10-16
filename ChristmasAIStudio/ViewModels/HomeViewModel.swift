import SwiftUI
import Combine

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var selectedCategory: StyleCategory = .santaLook
    @Published public var allStyles: [ChristmasStyle] = ChristmasStyle.allStyles
    @Published public var showPaywall: Bool = false
    @Published public var showSettings: Bool = false
    @Published public var selectedStyleForGeneration: ChristmasStyle?
    
    public init() {}
    
    public var featuredStyles: [ChristmasStyle] {
        allStyles.filter { $0.isPopular }
    }
    
    public var stylesForSelectedCategory: [ChristmasStyle] {
        allStyles.filter { $0.category == selectedCategory }
    }
    
    public func selectCategory(_ category: StyleCategory) {
        self.selectedCategory = category
    }
}
