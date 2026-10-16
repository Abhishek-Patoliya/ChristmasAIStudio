import SwiftUI

public struct BeforeAfterSlider: View {
    let beforeImage: UIImage
    let afterImage: UIImage
    
    @State private var splitPosition: CGFloat = 0.5
    @State private var isDragging: Bool = false
    
    public init(beforeImage: UIImage, afterImage: UIImage) {
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }
    
    public var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                // Background: After Image (Generated Christmas AI)
                Image(uiImage: afterImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                
                // Foreground: Before Image (Reference) clipped to splitPosition
                Image(uiImage: beforeImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .mask(
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: max(0, width * splitPosition))
                            Spacer(minLength: 0)
                        }
                    )
                
                // Divider Line
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 2.5)
                    .overlay(
                        Rectangle()
                            .stroke(Theme.gold, lineWidth: 1)
                    )
                    .position(x: width * splitPosition, y: height / 2)
                    .shadow(color: .black.opacity(0.5), radius: 4)
                
                // Drag Handle
                ZStack {
                    Circle()
                        .fill(Theme.velvetGradient)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(Theme.goldGradient, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.5), radius: 6)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .position(x: width * splitPosition, y: height / 2)
                
                // Badges
                VStack {
                    HStack {
                        // Before Tag
                        Text("ORIGINAL")
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.65))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .padding(.leading, 12)
                        
                        Spacer()
                        
                        // After Tag
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.gold)
                            Text("CHRISTMAS AI")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.gold)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.65))
                        .cornerRadius(6)
                        .padding(.trailing, 12)
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let locationX = value.location.x
                        let newPos = max(0.05, min(0.95, locationX / width))
                        splitPosition = newPos
                        if !isDragging {
                            isDragging = true
                            let generator = UISelectionFeedbackGenerator()
                            generator.selectionChanged()
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
        .cornerRadius(Theme.cornerRadiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                .stroke(Theme.gold.opacity(0.4), lineWidth: 1.5)
        )
    }
}
