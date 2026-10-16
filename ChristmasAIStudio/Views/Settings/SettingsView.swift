import SwiftUI

public struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Photo Processing & Privacy Disclosure")
                            .font(Theme.holidayTitle(size: 22))
                            .foregroundColor(Theme.snowWhite)
                        
                        Text("Last updated: Holiday Season 2026")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.parchment.opacity(0.6))
                        
                        Divider().background(Color.white.opacity(0.1))
                        
                        sectionView(
                            title: "1. Secure Photo Processing",
                            content: "Christmas AI Studio processes user-submitted photos solely to transform them into holiday-themed portraits requested by you. Transmission is strictly encrypted via secure HTTPS."
                        )
                        
                        sectionView(
                            title: "2. Zero Public Model Training",
                            content: "Your uploaded personal photos are never used to train public foundation models. Image data sent for rendering is transient and deleted from processing buffers immediately after generation."
                        )
                        
                        sectionView(
                            title: "3. No On-Device Secrets",
                            content: "To guarantee user security, this application does not embed third-party AI provider secrets or credentials. All generation requests route through our authenticated, rate-limited backend proxy."
                        )
                        
                        sectionView(
                            title: "4. Local On-Device Retention",
                            content: "All saved creations and greeting cards remain stored exclusively on your device in your app sandbox. You retain 100% control to delete individual items or wipe your entire creation gallery anytime in Settings."
                        )
                        
                        sectionView(
                            title: "5. Face Data & Ethical AI Notice",
                            content: "Our style transformation prompts are engineered to preserve recognizable facial geometry, expression, age, and natural likeness without collecting biometric identifiers. Artificial generation results may vary based on reference photo lighting."
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Privacy & Ethics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Theme.champagneGold)
                }
            }
        }
    }
    
    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Theme.holidayHeadline(size: 16))
                .foregroundColor(Theme.champagneGold)
            Text(content)
                .font(Theme.holidayBody(size: 14))
                .foregroundColor(Theme.parchment)
                .lineSpacing(3)
        }
    }
}

public struct SettingsView: View {
    @ObservedObject var appState = AppState.shared
    @AppStorage(Constants.keyBackendURL) private var backendURL: String = Constants.defaultBackendURL
    @AppStorage(Constants.keyMockMode) private var mockModeEnabled: Bool = false
    @State private var healthStatus: String?
    @State private var isCheckingHealth: Bool = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showWipeConfirmation: Bool = false
    @State private var showResetSuccessToast: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Section 1: Appearance & Festivities
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("HOLIDAY ATMOSPHERE")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                
                                Toggle("Snowfall Animation", isOn: $appState.isSnowEnabled)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Theme.snowWhite)
                                    .tint(Theme.forestGreen)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section 2: Backend AI Configuration
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("SECURE AI BACKEND")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Backend Server Endpoint")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.parchment)
                                    
                                    TextField("https://api.christmasaistudio.com", text: $backendURL)
                                        .textFieldStyle(.roundedBorder)
                                        .foregroundColor(.white)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                
                                HStack {
                                    Button(action: {
                                        Task { await testBackendConnection() }
                                    }) {
                                        HStack(spacing: 6) {
                                            if isCheckingHealth {
                                                ProgressView().tint(Theme.gold)
                                            } else {
                                                Image(systemName: "antenna.radiowaves.left.and.right")
                                            }
                                            Text("Test Connection")
                                                .font(.system(size: 13, weight: .semibold))
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(Capsule().fill(Color.white.opacity(0.1)))
                                        .foregroundColor(Theme.champagneGold)
                                    }
                                    
                                    Spacer()
                                    
                                    if let healthStatus {
                                        Text(healthStatus)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(healthStatus.contains("Online") ? Theme.forestGreen : Theme.brightBerry)
                                    }
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Toggle("Mock Development Mode", isOn: $mockModeEnabled)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.snowWhite)
                                    .tint(Theme.gold)
                                
                                Text("When enabled, the app renders clearly labeled sample results locally without requiring active OpenAI API tokens.")
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.parchment.opacity(0.65))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section 3: Privacy & Data Retention
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("PRIVACY & RETENTION")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                
                                Button(action: { showPrivacyPolicy = true }) {
                                    HStack {
                                        Image(systemName: "lock.shield.fill")
                                            .foregroundColor(Theme.gold)
                                        Text("Photo Processing & Privacy Disclosure")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Theme.snowWhite)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.parchment.opacity(0.5))
                                    }
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Button(action: { showWipeConfirmation = true }) {
                                    HStack {
                                        Image(systemName: "trash")
                                            .foregroundColor(Theme.brightBerry)
                                        Text("Clear All Local Saved Creations")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(Theme.brightBerry)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // App Info Footer
                        VStack(spacing: 4) {
                            Text("Christmas AI Studio for iPhone")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.champagneGold)
                            Text("Version 1.0.0 (Holiday 2026 Edition)")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.parchment.opacity(0.55))
                            Text("Engineered exclusively with SwiftUI & native Apple frameworks.")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.parchment.opacity(0.45))
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Settings & Privacy")
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .alert("Clear All Saved Creations?", isPresented: $showWipeConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    StorageService.shared.clearAllCreations()
                    showResetSuccessToast = true
                }
            } message: {
                Text("This will permanently delete all generated portraits stored locally in your gallery.")
            }
        }
    }
    
    private func testBackendConnection() async {
        isCheckingHealth = true
        defer { isCheckingHealth = false }
        
        let isHealthy = await BackendAPIService.shared.healthCheck()
        if isHealthy {
            healthStatus = "● Online (200 OK)"
        } else {
            healthStatus = "● Offline / Unreachable"
        }
    }
}
