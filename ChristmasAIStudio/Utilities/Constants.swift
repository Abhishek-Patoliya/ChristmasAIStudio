import Foundation

public enum Constants {
    public static let appName = "Christmas AI Studio"
    public static let seasonTarget = "Holiday 2026"
    public static let defaultBackendURL = "https://api.christmasaistudio.com"
    public static let localBackendURL = "http://127.0.0.1:8080"
    
    // StoreKit Product IDs
    public static let productCredits5 = "com.christmasai.studio.credits5"
    public static let productCredits15 = "com.christmasai.studio.credits15"
    public static let productCredits30 = "com.christmasai.studio.credits30"
    public static let productProWeekly = "com.christmasai.studio.pro.weekly"
    public static let productProHolidayPass = "com.christmasai.studio.pro.holiday2026"
    
    // Keys for UserDefaults
    public static let keyCredits = "user_credits_balance"
    public static let keyHasCompletedOnboarding = "has_completed_onboarding_2026"
    public static let keyBackendURL = "custom_backend_url"
    public static let keyMockMode = "enable_mock_mode"
    public static let keySnowAnimationEnabled = "snow_animation_enabled"
    public static let keyHapticsEnabled = "haptics_enabled"
    public static let keySavedCreations = "saved_creations_v1"
    
    // Free starter credits for every new installation
    public static let initialStarterCredits = 3
    
    // Max dimension for uploaded photos to optimize bandwidth and AI processing
    public static let maxImageDimension: CGFloat = 1536
    public static let thumbnailDimension: CGFloat = 400
}
