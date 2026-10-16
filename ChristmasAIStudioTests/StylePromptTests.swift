import XCTest
@testable import ChristmasAIStudio

final class StylePromptTests: XCTestCase {
    
    func testAllCategoriesRepresented() {
        let allCategories = StyleCategory.allCases
        XCTAssertEqual(allCategories.count, 7, "Must contain all 7 holiday categories required by specs")
        
        for category in allCategories {
            let styles = ChristmasStyle.allStyles.filter { $0.category == category }
            XCTAssertFalse(styles.isEmpty, "Category \(category.rawValue) must have at least one style defined")
        }
    }
    
    func testStyleUniqueIdentifiers() {
        let allStyles = ChristmasStyle.allStyles
        let idSet = Set(allStyles.map { $0.id })
        XCTAssertEqual(idSet.count, allStyles.count, "Every style must have a unique ID")
    }
    
    func testPromptQualityAndNegativePrompts() {
        for style in ChristmasStyle.allStyles {
            XCTAssertFalse(style.basePrompt.isEmpty, "Style \(style.id) prompt cannot be empty")
            XCTAssertFalse(style.negativePrompt.isEmpty, "Style \(style.id) negative prompt cannot be empty")
            XCTAssertTrue(style.basePrompt.count > 50, "Style \(style.id) prompt should be descriptive")
            XCTAssertFalse(style.recommendedPhotoTip.isEmpty, "Tip must guide the user on reference photo composition")
        }
    }
}
