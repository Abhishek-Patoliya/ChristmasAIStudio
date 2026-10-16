import SwiftUI

public struct SnowflakeParticle: Identifiable {
    public let id: Int
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    var sway: CGFloat
    var swayOffset: CGFloat
}

public struct SnowfallEffectView: View {
    @State private var particles: [SnowflakeParticle] = []
    let flakeCount: Int
    
    public init(flakeCount: Int = 35) {
        self.flakeCount = flakeCount
    }
    
    public var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    
                    for particle in particles {
                        let progress = (now * Double(particle.speed)).truncatingRemainder(dividingBy: 1.0)
                        let y = CGFloat(progress) * (size.height + 40) - 20
                        let swayAmount = sin(now * 1.5 + Double(particle.swayOffset)) * Double(particle.sway)
                        let x = (particle.x * size.width + CGFloat(swayAmount)).truncatingRemainder(dividingBy: size.width)
                        
                        let rect = CGRect(
                            x: x < 0 ? x + size.width : x,
                            y: y,
                            width: particle.size,
                            height: particle.size
                        )
                        
                        context.opacity = particle.opacity
                        context.fill(
                            Circle().path(in: rect),
                            with: .color(.white)
                        )
                    }
                }
            }
            .onAppear {
                setupParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
    
    private func setupParticles(in size: CGSize) {
        var items: [SnowflakeParticle] = []
        for i in 0..<flakeCount {
            items.append(
                SnowflakeParticle(
                    id: i,
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: 0...1),
                    size: CGFloat.random(in: 2.0...5.0),
                    opacity: Double.random(in: 0.3...0.85),
                    speed: CGFloat.random(in: 0.05...0.12),
                    sway: CGFloat.random(in: 8...24),
                    swayOffset: CGFloat.random(in: 0...(.pi * 2))
                )
            )
        }
        self.particles = items
    }
}
