import SwiftUI

public struct CreditBadgeView: View {
    @ObservedObject var storage = StorageService.shared
    let onTap: () -> Void
    
    public init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: storage.creditBalance.isProMember ? "crown.fill" : "sparkles")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.gold)
                
                Text(storage.creditBalance.isProMember ? "PRO" : "\(storage.creditBalance.availableCredits)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.snowWhite)
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.gold.opacity(0.8))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.45))
                    .overlay(
                        Capsule()
                            .stroke(Theme.gold.opacity(0.5), lineWidth: 1.0)
                    )
            )
        }
        .accessibilityLabel("Credits: \(storage.creditBalance.isProMember ? "Pro Unlimited" : "\(storage.creditBalance.availableCredits) available")")
    }
}
