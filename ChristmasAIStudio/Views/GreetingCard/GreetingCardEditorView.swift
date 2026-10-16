import SwiftUI

/// Isolated Card Canvas for live preview and SwiftUI ImageRenderer snapshotting
public struct GreetingCardCanvasView: View {
    let image: UIImage
    let config: GreetingCardConfig
    
    public init(image: UIImage, config: GreetingCardConfig) {
        self.image = image
        self.config = config
    }
    
    public var body: some View {
        ZStack {
            // Background Theme styling
            themeBackground
            
            VStack(spacing: 0) {
                // Top text banner if placement is topAndBottom
                if config.textPlacement == .topAndBottom {
                    VStack(spacing: 4) {
                        Text(config.headline)
                            .font(config.fontStyle.font(size: config.headlineFontSize))
                            .foregroundColor(themeTextColor)
                            .shadow(color: themeTextShadowColor, radius: 4)
                        
                        if !config.subheadline.isEmpty {
                            Text(config.subheadline)
                                .font(.system(size: 13, weight: .medium, design: .serif))
                                .foregroundColor(themeSubtitleColor)
                        }
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                }
                
                // Central Photo Frame
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 380)
                        .clipped()
                        .cornerRadius(config.showFestiveBorder ? 12 : 0)
                        .padding(config.showFestiveBorder ? 12 : 0)
                    
                    // Decorative Overlays (Postage stamp, foil corner ribbons)
                    if config.designTheme == .vintagePostage {
                        VStack {
                            HStack {
                                Spacer()
                                // Vintage Stamp
                                VStack(spacing: 2) {
                                    Image(systemName: "tree.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.forestGreen)
                                    Text("NORTH POLE\n2026")
                                        .font(.system(size: 7, weight: .black))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Theme.velvetCrimson)
                                }
                                .padding(6)
                                .background(Color.white.opacity(0.92))
                                .overlay(Rectangle().stroke(Color.black.opacity(0.3), lineWidth: 1))
                                .rotationEffect(.degrees(6))
                                .padding(24)
                            }
                            Spacer()
                        }
                    }
                    
                    // Centered Overlay Text if placement is overlayCentered
                    if config.textPlacement == .overlayCentered {
                        VStack(spacing: 8) {
                            Text(config.headline)
                                .font(config.fontStyle.font(size: config.headlineFontSize + 4))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 8)
                            
                            if !config.recipientOrFamilyName.isEmpty {
                                Text(config.recipientOrFamilyName)
                                    .font(.system(size: 16, weight: .semibold, design: .serif))
                                    .foregroundColor(Theme.champagneGold)
                                    .shadow(color: .black.opacity(0.8), radius: 6)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.35))
                        .cornerRadius(12)
                    }
                }
                
                // Bottom Text Banner
                if config.textPlacement != .overlayCentered {
                    VStack(spacing: 6) {
                        if config.textPlacement != .topAndBottom {
                            Text(config.headline)
                                .font(config.fontStyle.font(size: config.headlineFontSize))
                                .foregroundColor(themeTextColor)
                                .shadow(color: themeTextShadowColor, radius: 4)
                        }
                        
                        if !config.subheadline.isEmpty && config.textPlacement != .topAndBottom {
                            Text(config.subheadline)
                                .font(.system(size: 13, weight: .medium, design: .serif))
                                .foregroundColor(themeSubtitleColor)
                        }
                        
                        if !config.recipientOrFamilyName.isEmpty {
                            Text(config.recipientOrFamilyName)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(themeSubtitleColor)
                                .padding(.top, 2)
                        }
                        
                        Text(config.yearLabel)
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(themeSubtitleColor.opacity(0.75))
                            .tracking(1.5)
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(width: 360)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(themeBorderColor, lineWidth: config.showFestiveBorder ? 3 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var themeBackground: some View {
        switch config.designTheme {
        case .goldenOrnament:
            LinearGradient(
                colors: [Color(red: 0.16, green: 0.12, blue: 0.05), Color(red: 0.08, green: 0.06, blue: 0.02)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .snowyPine:
            LinearGradient(
                colors: [Theme.forestGreen, Theme.pineNeedle],
                startPoint: .top,
                endPoint: .bottom
            )
        case .velvetRoyalty:
            Theme.velvetGradient
        case .vintagePostage:
            Color(red: 0.95, green: 0.92, blue: 0.85)
        case .modernFrost:
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.18, blue: 0.25), Color(red: 0.06, green: 0.09, blue: 0.14)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .midnightMagic:
            LinearGradient(
                colors: [Color(red: 0.06, green: 0.07, blue: 0.16), Color(red: 0.02, green: 0.03, blue: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var themeTextColor: Color {
        switch config.designTheme {
        case .vintagePostage:
            return Theme.velvetCrimson
        default:
            return Theme.champagneGold
        }
    }
    
    private var themeSubtitleColor: Color {
        switch config.designTheme {
        case .vintagePostage:
            return Color(red: 0.25, green: 0.20, blue: 0.15)
        default:
            return Theme.snowWhite
        }
    }
    
    private var themeBorderColor: Color {
        switch config.designTheme {
        case .vintagePostage:
            return Theme.velvetCrimson.opacity(0.8)
        case .goldenOrnament:
            return Theme.gold
        case .velvetRoyalty:
            return Theme.champagneGold
        default:
            return Theme.gold.opacity(0.7)
        }
    }
    
    private var themeTextShadowColor: Color {
        switch config.designTheme {
        case .vintagePostage:
            return Color.clear
        default:
            return Color.black.opacity(0.6)
        }
    }
}

public struct GreetingCardEditorView: View {
    @StateObject private var viewModel: GreetingCardViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(image: UIImage) {
        _viewModel = StateObject(wrappedValue: GreetingCardViewModel(image: image))
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Live Card Canvas Preview
                        GreetingCardCanvasView(image: viewModel.selectedImage, config: viewModel.config)
                            .shadow(color: Color.black.opacity(0.5), radius: 18, x: 0, y: 8)
                            .padding(.top, 12)
                        
                        // Theme Selection Carousel
                        VStack(alignment: .leading, spacing: 10) {
                            Text("CARD THEME")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.champagneGold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(CardDesignTheme.allCases) { theme in
                                        Button(action: {
                                            viewModel.selectTheme(theme)
                                        }) {
                                            VStack(spacing: 6) {
                                                Image(systemName: theme.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(viewModel.config.designTheme == theme ? Theme.gold : .white)
                                                
                                                Text(theme.rawValue)
                                                    .font(.system(size: 11, weight: .semibold))
                                                    .foregroundColor(viewModel.config.designTheme == theme ? Theme.champagneGold : Theme.parchment)
                                            }
                                            .frame(width: 90, height: 70)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(viewModel.config.designTheme == theme ? Theme.pineNeedle : Theme.cardSurface)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(viewModel.config.designTheme == theme ? Theme.gold : Color.white.opacity(0.1), lineWidth: 1.5)
                                                    )
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Card Text Customization
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("CUSTOMIZE TEXT")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Headline")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.parchment)
                                    TextField("e.g. Merry Christmas", text: $viewModel.config.headline)
                                        .textFieldStyle(.roundedBorder)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Subheadline")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.parchment)
                                    TextField("e.g. May your days be merry & bright", text: $viewModel.config.subheadline)
                                        .textFieldStyle(.roundedBorder)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("From / Family Name")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.parchment)
                                    TextField("e.g. The Patoliy Family", text: $viewModel.config.recipientOrFamilyName)
                                        .textFieldStyle(.roundedBorder)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Typography and Layout
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("STYLE & LAYOUT")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.champagneGold)
                                
                                // Font Style Picker
                                Picker("Font", selection: $viewModel.config.fontStyle) {
                                    ForEach(CardFontStyle.allCases) { style in
                                        Text(style.rawValue).tag(style)
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                // Placement Picker
                                Picker("Placement", selection: $viewModel.config.textPlacement) {
                                    ForEach(CardTextPlacement.allCases) { placement in
                                        Text(placement.rawValue).tag(placement)
                                    }
                                }
                                .pickerStyle(.segmented)
                                
                                // Border Toggle
                                Toggle("Show Festive Border", isOn: $viewModel.config.showFestiveBorder)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.parchment)
                                    .tint(Theme.gold)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Export Buttons
                        VStack(spacing: 12) {
                            FestiveButton(
                                "Export & Save Card to Photos",
                                systemImage: "arrow.down.doc.fill",
                                style: .gold,
                                isLoading: viewModel.isExporting
                            ) {
                                renderAndExport()
                            }
                            
                            if let rendered = viewModel.renderedCardImage {
                                ShareLink(
                                    item: Image(uiImage: rendered),
                                    preview: SharePreview("Christmas Card 2026", image: Image(uiImage: rendered))
                                ) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Share Card Online")
                                            .font(Theme.holidayHeadline(size: 16))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Theme.velvetGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(Theme.cornerRadiusMedium)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Greeting Card Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
            }
            .overlay(alignment: .top) {
                if viewModel.exportSuccessToast {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.gold)
                        Text("Holiday card exported to Photos!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(Theme.cornerRadiusPill)
                    .overlay(Capsule().stroke(Theme.gold.opacity(0.5), lineWidth: 1))
                    .padding(.top, 16)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { viewModel.exportSuccessToast = false }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - High-Resolution Image Rendering via ImageRenderer
    @MainActor
    private func renderAndExport() {
        let canvas = GreetingCardCanvasView(image: viewModel.selectedImage, config: viewModel.config)
        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 3.0 // 3x scale for crisp Retina / Print export
        
        if let uiImage = renderer.uiImage {
            viewModel.renderedCardImage = uiImage
            Task {
                await viewModel.exportCard(using: uiImage)
            }
        }
    }
}
