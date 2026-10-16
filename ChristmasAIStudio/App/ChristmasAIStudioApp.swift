import SwiftUI

@main
struct ChristmasAIStudioApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var storeKit = StoreKitManager.shared
    
    init() {
        // Enforce dark holiday styling by default
        UIView.appearance().tintColor = UIColor(red: 0.90, green: 0.75, blue: 0.38, alpha: 1.0)
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !appState.hasCompletedOnboarding {
                    OnboardingView()
                } else {
                    MainTabView()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
