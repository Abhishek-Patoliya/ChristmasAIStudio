import Foundation

public struct CreditBalance: Codable, Equatable {
    public var availableCredits: Int
    public var isProMember: Bool
    public var proExpirationDate: Date?
    public var totalCreationsCount: Int
    public var lastPurchasedDate: Date?
    
    public init(
        availableCredits: Int = Constants.initialStarterCredits,
        isProMember: Bool = false,
        proExpirationDate: Date? = nil,
        totalCreationsCount: Int = 0,
        lastPurchasedDate: Date? = nil
    ) {
        self.availableCredits = availableCredits
        self.isProMember = isProMember
        self.proExpirationDate = proExpirationDate
        self.totalCreationsCount = totalCreationsCount
        self.lastPurchasedDate = lastPurchasedDate
    }
    
    public var canGenerate: Bool {
        if isProMember {
            if let proExpirationDate {
                return proExpirationDate > Date()
            }
            return true
        }
        return availableCredits > 0
    }
    
    public var statusDescription: String {
        if isProMember {
            return "Christmas Pro (Unlimited)"
        } else {
            return "\(availableCredits) Credits Available"
        }
    }
}

public struct CreditPackage: Identifiable {
    public let id: String
    public let title: String
    public let creditAmount: Int
    public let priceString: String
    public let subtitle: String
    public let badge: String?
    public let isPopular: Bool
    
    public static let availablePackages: [CreditPackage] = [
        CreditPackage(
            id: Constants.productCredits5,
            title: "5 Holiday Credits",
            creditAmount: 5,
            priceString: "$2.99",
            subtitle: "Try out a few festive looks",
            badge: nil,
            isPopular: false
        ),
        CreditPackage(
            id: Constants.productCredits15,
            title: "15 Holiday Credits",
            creditAmount: 15,
            priceString: "$5.99",
            subtitle: "Create portraits for your whole family",
            badge: "Most Popular",
            isPopular: true
        ),
        CreditPackage(
            id: Constants.productCredits30,
            title: "30 Holiday Credits",
            creditAmount: 30,
            priceString: "$9.99",
            subtitle: "Unlimited creative holiday party fun",
            badge: "Best Value",
            isPopular: false
        )
    ]
}
