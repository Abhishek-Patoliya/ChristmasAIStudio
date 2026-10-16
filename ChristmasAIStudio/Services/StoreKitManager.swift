import Foundation
import StoreKit

@MainActor
public final class StoreKitManager: ObservableObject {
    public static let shared = StoreKitManager()
    
    @Published public private(set) var products: [Product] = []
    @Published public private(set) var purchasedProductIDs = Set<String>()
    @Published public private(set) var isProSubscribed: Bool = false
    @Published public private(set) var isLoadingProducts: Bool = false
    @Published public private(set) var purchaseError: String?
    
    private var transactionListener: Task<Void, Error>?
    
    public init() {
        startTransactionListener()
        Task {
            await loadProducts()
            await updatePurchasedStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Transaction Updates Listener
    private func startTransactionListener() {
        transactionListener = Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try self?.checkVerified(result)
                    if let transaction {
                        await self?.handleTransaction(transaction)
                        await transaction.finish()
                    }
                } catch {
                    print("StoreKit transaction verification error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Load Products
    public func loadProducts() async {
        isLoadingProducts = true
        defer { isLoadingProducts = false }
        
        let productIdentifiers: [String] = [
            Constants.productCredits5,
            Constants.productCredits15,
            Constants.productCredits30,
            Constants.productProWeekly,
            Constants.productProHolidayPass
        ]
        
        do {
            let loadedProducts = try await Product.products(for: productIdentifiers)
            self.products = loadedProducts.sorted(by: { $0.price < $1.price })
        } catch {
            print("Failed to load StoreKit products: \(error)")
            self.purchaseError = "Failed to load holiday packages. Please try again."
        }
    }
    
    // MARK: - Purchase Flow
    public func purchase(_ product: Product) async throws -> Bool {
        purchaseError = nil
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await handleTransaction(transaction)
            await transaction.finish()
            await updatePurchasedStatus()
            return true
            
        case .userCancelled:
            return false
            
        case .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    // MARK: - Restore Purchases
    public func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedStatus()
        } catch {
            self.purchaseError = "Could not sync purchases: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Handle Completed Transaction
    private func handleTransaction(_ transaction: Transaction) async {
        let productID = transaction.productID
        
        if productID == Constants.productCredits5 {
            StorageService.shared.addCredits(5)
        } else if productID == Constants.productCredits15 {
            StorageService.shared.addCredits(15)
        } else if productID == Constants.productCredits30 {
            StorageService.shared.addCredits(30)
        } else if productID == Constants.productProWeekly || productID == Constants.productProHolidayPass {
            StorageService.shared.setProStatus(true, expiration: transaction.expirationDate)
        }
    }
    
    // MARK: - Verify Active Entitlements
    public func updatePurchasedStatus() async {
        var activePro = false
        var purchasedIDs = Set<String>()
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchasedIDs.insert(transaction.productID)
                
                if transaction.productID == Constants.productProWeekly ||
                    transaction.productID == Constants.productProHolidayPass {
                    if let expiration = transaction.expirationDate {
                        if expiration > Date() {
                            activePro = true
                        }
                    } else {
                        // Non-expiring lifetime/season pass
                        activePro = true
                    }
                }
            } catch {
                print("Failed to verify entitlement: \(error)")
            }
        }
        
        self.purchasedProductIDs = purchasedIDs
        self.isProSubscribed = activePro
        StorageService.shared.setProStatus(activePro)
    }
    
    // MARK: - Cryptographic Verification
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
}
