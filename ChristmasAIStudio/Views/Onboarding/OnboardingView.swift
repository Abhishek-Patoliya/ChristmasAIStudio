import SwiftUI

public struct OnboardingView: View {
    @ObservedObject var appState = AppState.shared
    @State private var currentStep = 0
    
    let slides: [(icon: String, title: String, description: String)] = [
        (
            icon: "sparkles",
            title: "Holiday Magic in Seconds",
            description: "Transform your everyday photos into breathtaking Christmas portraits, snowy mountain wonderlands, and cozy fireplace scenes."
        ),
        (
            icon: "person.crop.artframe",
            title: "Preserve Your Natural Smile",
            description: "Advanced AI image rendering preserves your recognizable facial features, authentic expression, skin tone, and age while adding festive warmth."
        ),
        (
            icon: "envelope.badge.fill",
            title: "Personalized Greeting Cards",
            description: "Turn your Christmas portraits into bespoke holiday greeting cards with elegant local typography, ready to print and share."
        )
    ]
    
    public var body: some View {
        ZStack {
            Theme.holidayBackgroundGradient
                .ignoresSafeArea()
            
            if appState.isSnowEnabled {
                SnowfallEffectView(flakeCount: 40)
            }
            
            VStack(spacing: 24) {
                // Header Brand
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .foregroundColor(Theme.gold)
                        Text("CHRISTMAS AI STUDIO")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.champagneGold)
                            .tracking(2.0)
                        Image(systemName: "sparkles")
                            .foregroundColor(Theme.gold)
                    }
                    .padding(.top, 24)
                    
                    Text("Holiday Season 2026")
                        .font(Theme.holidayBody(size: 13))
                        .foregroundColor(Theme.parchment.opacity(0.7))
                }
                
                Spacer()
                
                // Carousel Content
                TabView(selection: $currentStep) {
                    ForEach(slides.indices, id: \.self) { index in
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Theme.lightPine.opacity(0.35))
                                    .frame(width: 140, height: 140)
                                    .overlay(
                                        Circle()
                                            .stroke(Theme.goldGradient, lineWidth: 2)
                                    )
                                    .shadow(color: Theme.gold.opacity(0.3), radius: 15)
                                
                                Image(systemName: slides[index].icon)
                                    .font(.system(size: 56, weight: .light))
                                    .foregroundStyle(Theme.goldGradient)
                            }
                            .padding(.bottom, 12)
                            
                            Text(slides[index].title)
                                .font(Theme.holidayTitle(size: 26))
                                .foregroundColor(Theme.snowWhite)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                            
                            Text(slides[index].description)
                                .font(Theme.holidayBody(size: 16))
                                .foregroundColor(Theme.parchment.opacity(0.85))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 32)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 380)
                
                Spacer()
                
                // Privacy Notice
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.gold)
                    Text("Your photos are processed securely and never used to train public AI models.")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.parchment.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Action Button
                VStack(spacing: 12) {
                    FestiveButton("Get Started (+3 Starter Credits)", systemImage: "gift.fill", style: .gold) {
                        appState.hasCompletedOnboarding = true
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 28)
            }
        }
    }
}
