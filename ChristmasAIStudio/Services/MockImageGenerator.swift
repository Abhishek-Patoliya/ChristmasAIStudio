import UIKit
import CoreGraphics

/// Generates clearly labeled holiday sample images for development and testing
/// when OpenAI backend API credentials are not configured.
public enum MockImageGenerator {
    public static func generateSampleFestiveImage(
        for style: ChristmasStyle,
        originalImage: UIImage?,
        size: CGSize = CGSize(width: 1024, height: 1024)
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            let rect = CGRect(origin: .zero, size: size)
            
            // 1. Draw rich holiday background gradient
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var startColor: UIColor
            var endColor: UIColor
            
            switch style.category {
            case .santaLook:
                startColor = UIColor(red: 0.50, green: 0.05, blue: 0.08, alpha: 1.0)
                endColor = UIColor(red: 0.15, green: 0.02, blue: 0.03, alpha: 1.0)
            case .christmasPortrait:
                startColor = UIColor(red: 0.08, green: 0.20, blue: 0.14, alpha: 1.0)
                endColor = UIColor(red: 0.02, green: 0.08, blue: 0.05, alpha: 1.0)
            case .winterWonderland:
                startColor = UIColor(red: 0.15, green: 0.25, blue: 0.38, alpha: 1.0)
                endColor = UIColor(red: 0.05, green: 0.10, blue: 0.20, alpha: 1.0)
            case .cozyFireplace:
                startColor = UIColor(red: 0.55, green: 0.22, blue: 0.08, alpha: 1.0)
                endColor = UIColor(red: 0.20, green: 0.06, blue: 0.02, alpha: 1.0)
            case .coupleChristmas:
                startColor = UIColor(red: 0.45, green: 0.08, blue: 0.22, alpha: 1.0)
                endColor = UIColor(red: 0.14, green: 0.03, blue: 0.08, alpha: 1.0)
            case .familyHoliday:
                startColor = UIColor(red: 0.18, green: 0.32, blue: 0.20, alpha: 1.0)
                endColor = UIColor(red: 0.35, green: 0.08, blue: 0.10, alpha: 1.0)
            case .christmasGreetingCards:
                startColor = UIColor(red: 0.30, green: 0.24, blue: 0.14, alpha: 1.0)
                endColor = UIColor(red: 0.10, green: 0.08, blue: 0.04, alpha: 1.0)
            }
            
            let colors = [startColor.cgColor, endColor.cgColor] as CFArray
            let locations: [CGFloat] = [0.0, 1.0]
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations) {
                cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
            }
            
            // 2. Draw subtle reference photo if provided (stylized blend)
            if let originalImage {
                let photoRect = CGRect(x: size.width * 0.15, y: size.height * 0.12, width: size.width * 0.7, height: size.height * 0.7)
                cgContext.saveGState()
                let clipPath = UIBezierPath(roundedRect: photoRect, cornerRadius: 40)
                clipPath.addClip()
                originalImage.draw(in: photoRect, blendMode: .luminosity, alpha: 0.45)
                cgContext.restoreGState()
            }
            
            // 3. Draw festive bokeh fairy lights
            let fairyPositions: [(CGPoint, CGFloat, UIColor)] = [
                (CGPoint(x: 120, y: 150), 45, UIColor(red: 1.0, green: 0.85, blue: 0.4, alpha: 0.5)),
                (CGPoint(x: 900, y: 200), 60, UIColor(red: 1.0, green: 0.80, blue: 0.5, alpha: 0.4)),
                (CGPoint(x: 200, y: 800), 50, UIColor(red: 1.0, green: 0.90, blue: 0.6, alpha: 0.45)),
                (CGPoint(x: 820, y: 750), 70, UIColor(red: 1.0, green: 0.85, blue: 0.4, alpha: 0.5)),
                (CGPoint(x: 512, y: 100), 35, UIColor(red: 1.0, green: 0.95, blue: 0.7, alpha: 0.6)),
                (CGPoint(x: 150, y: 480), 30, UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.4)),
                (CGPoint(x: 880, y: 520), 40, UIColor(red: 0.3, green: 0.8, blue: 0.5, alpha: 0.4))
            ]
            
            for (pos, radius, col) in fairyPositions {
                let glowPath = UIBezierPath(arcCenter: pos, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                col.setFill()
                glowPath.fill()
            }
            
            // 4. Draw decorative gold corner borders
            let goldColor = UIColor(red: 0.90, green: 0.75, blue: 0.38, alpha: 0.9)
            goldColor.setStroke()
            let borderMargin: CGFloat = 32
            let cornerLen: CGFloat = 80
            let cornerPath = UIBezierPath()
            cornerPath.lineWidth = 4
            
            // Top-left
            cornerPath.move(to: CGPoint(x: borderMargin, y: borderMargin + cornerLen))
            cornerPath.addLine(to: CGPoint(x: borderMargin, y: borderMargin))
            cornerPath.addLine(to: CGPoint(x: borderMargin + cornerLen, y: borderMargin))
            // Top-right
            cornerPath.move(to: CGPoint(x: size.width - borderMargin - cornerLen, y: borderMargin))
            cornerPath.addLine(to: CGPoint(x: size.width - borderMargin, y: borderMargin))
            cornerPath.addLine(to: CGPoint(x: size.width - borderMargin, y: borderMargin + cornerLen))
            // Bottom-left
            cornerPath.move(to: CGPoint(x: borderMargin, y: size.height - borderMargin - cornerLen))
            cornerPath.addLine(to: CGPoint(x: borderMargin, y: size.height - borderMargin))
            cornerPath.addLine(to: CGPoint(x: borderMargin + cornerLen, y: size.height - borderMargin))
            // Bottom-right
            cornerPath.move(to: CGPoint(x: size.width - borderMargin - cornerLen, y: size.height - borderMargin))
            cornerPath.addLine(to: CGPoint(x: size.width - borderMargin, y: size.height - borderMargin))
            cornerPath.addLine(to: CGPoint(x: size.width - borderMargin, y: size.height - borderMargin - cornerLen))
            cornerPath.stroke()
            
            // 5. Draw Christmas Icon / Graphic in center
            let iconConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .light)
            if let iconImage = UIImage(systemName: style.systemIcon, withConfiguration: iconConfig)?.withTintColor(UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 0.85), renderingMode: .alwaysOriginal) {
                let iconOrigin = CGPoint(x: (size.width - iconImage.size.width) / 2, y: size.height * 0.36)
                iconImage.draw(at: iconOrigin)
            }
            
            // 6. Draw Style Title & Festive Description
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Georgia-Bold", size: 48) ?? UIFont.boldSystemFont(ofSize: 48),
                .foregroundColor: UIColor(red: 0.98, green: 0.94, blue: 0.85, alpha: 1.0),
                .paragraphStyle: paragraphStyle
            ]
            let titleString = NSAttributedString(string: style.name, attributes: titleAttrs)
            titleString.draw(in: CGRect(x: 40, y: size.height * 0.58, width: size.width - 80, height: 60))
            
            let catAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .medium),
                .foregroundColor: goldColor,
                .paragraphStyle: paragraphStyle
            ]
            let catString = NSAttributedString(string: "✦ \(style.category.rawValue) ✦", attributes: catAttrs)
            catString.draw(in: CGRect(x: 40, y: size.height * 0.65, width: size.width - 80, height: 36))
            
            // 7. Clear disclaimer banner so mock results are NEVER misrepresented
            let badgeRect = CGRect(x: (size.width - 460) / 2, y: size.height - 110, width: 460, height: 50)
            let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: 25)
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75).setFill()
            badgePath.fill()
            goldColor.setStroke()
            badgePath.lineWidth = 1.5
            badgePath.stroke()
            
            let badgeAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let badgeText = NSAttributedString(string: "MOCK DEVELOPMENT PREVIEW", attributes: badgeAttrs)
            badgeText.draw(in: CGRect(x: badgeRect.origin.x, y: badgeRect.origin.y + 14, width: badgeRect.width, height: 30))
        }
    }
}
