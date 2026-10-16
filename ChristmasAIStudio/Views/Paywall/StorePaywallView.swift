import SwiftUI
import StoreKit

public struct StorePaywallView: View {
    @ObservedObject var storeKit = StoreKitManager.shared
    @ObservedObject var storage = StorageService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var purchasingProductID: String?
    @State private var showRestoreSuccessToast: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                SnowfallEffectView(flakeCount: 30)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Holiday Pro Hero Header
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Theme.lightPine.opacity(0.35))
                                    .frame(width: 84, height: 84)
                                    .overlay(Circle().stroke(Theme.goldGradient, lineWidth: 2))
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Theme.goldGradient)
                            }
                            
                            Text("Christmas AI Studio Pro")
                                .font(Theme.holidayTitle(size: 26))
                                .foregroundColor(Theme.snowWhite)
                            
                            Text("Unlock unlimited 4K transformations, priority AI queue, and high-resolution greeting card printing.")
                                .font(Theme.holidayBody(size: 14))
                                .foregroundColor(Theme.parchment.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 16)
                        
                        // Active Status Banner if user already has Pro or Credits
                        FestiveCard(highlighted: storage.creditBalance.isProMember) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CURRENT BALANCE")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                    
                                    Text(storage.creditBalance.statusDescription)
                                        .font(Theme.holidayHeadline(size: 18))
                                        .foregroundColor(Theme.snowWhite)
                                }
                                Spacer()
                                Image(systemName: storage.creditBalance.isProMember ? "checkmark.seal.fill" : "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.gold)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section 1: Consumable Credit Packs
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("AI CREDIT PACKS")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                Spacer()
                                Text("Never Expire")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.parchment.opacity(0.7))
                            }
                            .padding(.horizontal)
                            
                            ForEach(CreditPackage.availablePackages) { pack in
                                let product = storeKit.products.first(where: { $0.id == pack.id })
                                let priceText = product?.displayPrice ?? pack.priceString
                                
                                Button(action: {
                                    Task { await purchasePackage(packId: pack.id) }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack(spacing: 8) {
                                                Text(pack.title)
                                                    .font(Theme.holidayHeadline(size: 16))
                                                    .foregroundColor(Theme.snowWhite)
                                                
                                                if let badge = pack.badge {
                                                    Text(badge.uppercased())
                                                        .font(.system(size: 9, weight: .heavy))
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(pack.isPopular ? Theme.velvetCrimson : Theme.forestGreen)
                                                        .cornerRadius(4)
                                                }
                                            }
                                            
                                            Text(pack.subtitle)
                                                .font(Theme.holidayBody(size: 12))
                                                .foregroundColor(Theme.parchment.opacity(0.75))
                                        }
                                        
                                        Spacer()
                                        
                                        if purchasingProductID == pack.id {
                                            ProgressView()
                                                .tint(Theme.gold)
                                        } else {
                                            Text(priceText)
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Theme.champagneGold)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(Color.white.opacity(0.12))
                                                        .overlay(Capsule().stroke(Theme.gold.opacity(0.6), lineWidth: 1))
                                                )
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                            .fill(Theme.cardSurface.opacity(0.85))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                                    .stroke(pack.isPopular ? Theme.goldGradient : LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .top, endPoint: .bottom), lineWidth: pack.isPopular ? 1.5 : 1)
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Section 2: Seasonal Unlimited Subscriptions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SEASON PASS & SUBSCRIPTIONS")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.champagneGold)
                                .padding(.horizontal)
                            
                            // Holiday 2026 Season Pass
                            let passProduct = storeKit.products.first(where: { $0.id == Constants.productProHolidayPass })
                            Button(action: {
                                Task { await purchasePackage(packId: Constants.productProHolidayPass) }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 8) {
                                            Text("Holiday 2026 Pass")
                                                .font(Theme.holidayHeadline(size: 16))
                                                .foregroundColor(Theme.snowWhite)
                                            
                                            Text("VIP PASS")
                                                .font(.system(size: 9, weight: .heavy))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Theme.velvetCrimson)
                                                .cornerRadius(4)
                                        }
                                        Text("Full season access through Jan 2027 with VIP priority")
                                            .font(Theme.holidayBody(size: 12))
                                            .foregroundColor(Theme.parchment.opacity(0.75))
                                    }
                                    Spacer()
                                    
                                    if purchasingProductID == Constants.productProHolidayPass {
                                        ProgressView().tint(Theme.gold)
                                    } else {
                                        Text(passProduct?.displayPrice ?? "$19.99")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(Theme.champagneGold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(Theme.velvetGradient)
                                                    .overlay(Capsule().stroke(Theme.gold.opacity(0.7), lineWidth: 1))
                                            )
                                    }
                                }
                                .padding()
                                .festiveCardStyle(highlighted: true)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            
                            // Weekly Pro
                            let weeklyProduct = storeKit.products.first(where: { $0.id == Constants.productProWeekly })
                            Button(action: {
                                Task { await purchasePackage(packId: Constants.productProWeekly) }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Weekly Pro Pass")
                                            .font(Theme.holidayHeadline(size: 15))
                                            .foregroundColor(Theme.snowWhite)
                                        Text("Renews weekly, cancel anytime in iOS Settings")
                                            .font(Theme.holidayBody(size: 12))
                                            .foregroundColor(Theme.parchment.opacity(0.75))
                                    }
                                    Spacer()
                                    
                                    if purchasingProductID == Constants.productProWeekly {
                                        ProgressView().tint(Theme.gold)
                                    } else {
                                        Text(weeklyProduct?.displayPrice ?? "$4.99/wk")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(Theme.champagneGold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Capsule().fill(Color.white.opacity(0.1)))
                                    }
                                }
                                .padding()
                                .festiveCardStyle()
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                        
                        // Error message if purchase failed
                        if let error = storeKit.purchaseError {
                            Text(error)
                                .font(Theme.holidayBody(size: 13))
                                .foregroundColor(Theme.brightBerry)
                                .padding(.horizontal)
                        }
                        
                        // Restore Purchases & Disclosures
                        VStack(spacing: 8) {
                            Button("Restore Purchases") {
                                Task {
                                    await storeKit.restorePurchases()
                                    showRestoreSuccessToast = true
                                }
                            }
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.champagneGold)
                            
                            Text("Payment is charged to your Apple ID account at confirmation of purchase. Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period.")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.parchment.opacity(0.55))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Holiday Store")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
            }
        }
    }
    
    private func purchasePackage(packId: String) async {
        purchasingProductID = packId
        defer { purchasingProductID = nil }
        
        if let product = storeKit.products.first(where: { $0.id == packId }) {
            do {
                _ = try await storeKit.purchase(product)
            } catch {
                print("Purchase failed: \(error)")
            }
        } else {
            // Local sandbox fallback for testing
            if packId == Constants.productCredits5 {
                storage.addCredits(5)
            } else if packId == Constants.productCredits15 {
                storage.addCredits(15)
            } else if packId == Constants.productCredits30 {
                storage.addCredits(30)
            } else {
                storage.setProStatus(true)
            }
        }
    }
}
