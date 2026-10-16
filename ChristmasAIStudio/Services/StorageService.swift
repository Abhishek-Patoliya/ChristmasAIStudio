import Foundation
import Combine

public final class StorageService: ObservableObject {
    public static let shared = StorageService()
    
    @Published public private(set) var savedCreations: [GeneratedImage] = []
    @Published public private(set) var creditBalance: CreditBalance = CreditBalance()
    
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    private let creationsFileURL: URL
    private let creditsFileURL: URL
    
    private init() {
        self.documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.creationsFileURL = documentsDirectory.appendingPathComponent("saved_creations_2026.json")
        self.creditsFileURL = documentsDirectory.appendingPathComponent("credit_balance_2026.json")
        
        loadCredits()
        loadSavedCreations()
    }
    
    // MARK: - Creations Storage
    public func saveCreation(_ image: GeneratedImage) {
        // Prepend so the newest creation shows first
        savedCreations.removeAll(where: { $0.id == image.id })
        savedCreations.insert(image, at: 0)
        persistCreations()
        
        // Deduct 1 credit if not pro
        deductCreditForGeneration()
    }
    
    public func toggleFavorite(for id: UUID) {
        if let index = savedCreations.firstIndex(where: { $0.id == id }) {
            savedCreations[index].isFavorite.toggle()
            persistCreations()
        }
    }
    
    public func deleteCreation(id: UUID) {
        savedCreations.removeAll(where: { $0.id == id })
        persistCreations()
    }
    
    public func clearAllCreations() {
        savedCreations.removeAll()
        persistCreations()
    }
    
    private func persistCreations() {
        do {
            let data = try JSONEncoder().encode(savedCreations)
            try data.write(to: creationsFileURL, options: .atomic)
        } catch {
            print("Failed to persist creations: \(error)")
        }
    }
    
    private func loadSavedCreations() {
        guard fileManager.fileExists(atPath: creationsFileURL.path) else { return }
        do {
            let data = try Data(contentsOf: creationsFileURL)
            let loaded = try JSONDecoder().decode([GeneratedImage].self, from: data)
            self.savedCreations = loaded
        } catch {
            print("Failed to load creations: \(error)")
        }
    }
    
    // MARK: - Credits Management
    public func addCredits(_ amount: Int) {
        creditBalance.availableCredits += amount
        creditBalance.lastPurchasedDate = Date()
        persistCredits()
    }
    
    public func deductCreditForGeneration() {
        guard !creditBalance.isProMember else {
            creditBalance.totalCreationsCount += 1
            persistCredits()
            return
        }
        if creditBalance.availableCredits > 0 {
            creditBalance.availableCredits -= 1
        }
        creditBalance.totalCreationsCount += 1
        persistCredits()
    }
    
    public func setProStatus(_ isPro: Bool, expiration: Date? = nil) {
        creditBalance.isProMember = isPro
        creditBalance.proExpirationDate = expiration
        persistCredits()
    }
    
    private func persistCredits() {
        do {
            let data = try JSONEncoder().encode(creditBalance)
            try data.write(to: creditsFileURL, options: .atomic)
        } catch {
            print("Failed to save credit balance: \(error)")
        }
    }
    
    private func loadCredits() {
        guard fileManager.fileExists(atPath: creditsFileURL.path) else {
            // First install starter credits
            self.creditBalance = CreditBalance(availableCredits: Constants.initialStarterCredits)
            persistCredits()
            return
        }
        do {
            let data = try Data(contentsOf: creditsFileURL)
            self.creditBalance = try JSONDecoder().decode(CreditBalance.self, from: data)
        } catch {
            self.creditBalance = CreditBalance(availableCredits: Constants.initialStarterCredits)
        }
    }
}
