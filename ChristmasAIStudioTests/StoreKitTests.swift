import XCTest
@testable import ChristmasAIStudio

final class StoreKitTests: XCTestCase {
    
    func testInitialStarterCredits() {
        let balance = CreditBalance()
        XCTAssertEqual(balance.availableCredits, Constants.initialStarterCredits)
        XCTAssertTrue(balance.canGenerate)
    }
    
    func testCreditDeduction() {
        var balance = CreditBalance(availableCredits: 2)
        XCTAssertTrue(balance.canGenerate)
        
        balance.availableCredits -= 1
        XCTAssertEqual(balance.availableCredits, 1)
        XCTAssertTrue(balance.canGenerate)
        
        balance.availableCredits -= 1
        XCTAssertEqual(balance.availableCredits, 0)
        XCTAssertFalse(balance.canGenerate)
    }
    
    func testProMembershipUnlimited() {
        let proBalance = CreditBalance(availableCredits: 0, isProMember: true)
        XCTAssertTrue(proBalance.canGenerate, "Pro users can generate even with 0 consumable credits")
    }
    
    func testAvailablePackages() {
        let packages = CreditPackage.availablePackages
        XCTAssertEqual(packages.count, 3)
        XCTAssertEqual(packages[0].creditAmount, 5)
        XCTAssertEqual(packages[1].creditAmount, 15)
        XCTAssertEqual(packages[2].creditAmount, 30)
    }
}
