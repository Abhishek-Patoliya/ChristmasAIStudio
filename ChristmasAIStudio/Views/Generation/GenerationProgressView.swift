import SwiftUI

public struct GenerationProgressView: View {
    @ObservedObject var viewModel: GenerationViewModel
    @State private var pulseGlow: Bool = false
    @State private var rotateOrnament: Double = 0
    
    public init(viewModel: GenerationViewModel) {
        self.viewModel = viewModel
    }
    
    private var progressValue: Double {
        if case .generating(let progress, _) = viewModel.state {
            return progress
        }
        return 0.1
    }
    
    private var currentStep: String {
        if case .generating(_, let step) = viewModel.state {
            return step
        }
        return "Creating holiday magic..."
    }
    
    public var body: some View {
        ZStack {
            Theme.holidayBackgroundGradient
                .ignoresSafeArea()
            
            SnowfallEffectView(flakeCount: 45)
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated Glowing Christmas Bauble
                ZStack {
                    Circle()
                        .fill(Theme.velvetGradient)
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulseGlow ? 1.08 : 0.96)
                        .shadow(color: Theme.christmasRed.opacity(0.6), radius: pulseGlow ? 35 : 15)
                        .overlay(
                            Circle()
                                .stroke(Theme.goldGradient, lineWidth: 3)
                        )
                    
                    // Rotating star rays
                    Image(systemName: "sparkles")
                        .font(.system(size: 64, weight: .light))
                        .foregroundStyle(Theme.goldGradient)
                        .rotationEffect(.degrees(rotateOrnament))
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        pulseGlow = true
                    }
                    withAnimation(.linear(duration: 12.0).repeatForever(autoreverses: false)) {
                        rotateOrnament = 360
                    }
                }
                
                // Title and Style Name
                VStack(spacing: 8) {
                    Text("Transforming Your Portrait")
                        .font(Theme.holidayTitle(size: 24))
                        .foregroundColor(Theme.snowWhite)
                    
                    Text(viewModel.selectedStyle.name)
                        .font(Theme.holidayHeadline(size: 16))
                        .foregroundStyle(Theme.goldGradient)
                }
                
                // Step Description
                VStack(spacing: 12) {
                    Text(currentStep)
                        .font(Theme.holidayBody(size: 15))
                        .foregroundColor(Theme.parchment)
                        .multilineTextAlignment(.center)
                        .frame(height: 44)
                        .animation(.easeInOut, value: currentStep)
                    
                    // Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 10)
                            
                            Capsule()
                                .fill(Theme.goldGradient)
                                .frame(width: max(10, geo.size.width * CGFloat(progressValue)), height: 10)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progressValue)
                        }
                    }
                    .frame(height: 10)
                    .padding(.horizontal, 36)
                    
                    Text("\(Int(progressValue * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.champagneGold)
                }
                
                Spacer()
                
                // Security & Privacy Guarantee note
                HStack(spacing: 6) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.gold)
                    Text("Secure HTTPS • Face data is discarded immediately after render")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.parchment.opacity(0.65))
                }
                .padding(.bottom, 8)
                
                // Cancel Button
                Button(action: {
                    viewModel.cancelGeneration()
                }) {
                    Text("Cancel Generation")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.parchment.opacity(0.8))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .padding(.bottom, 36)
            }
        }
    }
}
