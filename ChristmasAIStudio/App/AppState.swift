import SwiftUI
import Combine

@MainActor
public final class AppState: ObservableObject {
    public static let shared = AppState()
    
    @AppStorage(Constants.keyHasCompletedOnboarding) public var hasCompletedOnboarding: Bool = false
    @AppStorage(Constants.keySnowAnimationEnabled) public var isSnowEnabled: Bool = true
    @Published public var selectedTab: Int = 0
    @Published public var showPaywall: Bool = false
    
    public init() {}
}
