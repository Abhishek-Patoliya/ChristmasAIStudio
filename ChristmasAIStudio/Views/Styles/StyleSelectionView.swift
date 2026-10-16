import SwiftUI

public struct StyleDetailSheet: View {
    let style: ChristmasStyle
    let onStartWithStyle: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    public init(style: ChristmasStyle, onStartWithStyle: @escaping () -> Void) {
        self.style = style
        self.onStartWithStyle = onStartWithStyle
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Hero Visual Box
                        ZStack {
                            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.lightPine, Theme.pineNeedle],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 220)
                                .overlay(
                                    VStack(spacing: 12) {
                                        Image(systemName: style.systemIcon)
                                            .font(.system(size: 64, weight: .light))
                                            .foregroundStyle(Theme.goldGradient)
                                            .shadow(color: Theme.gold.opacity(0.5), radius: 10)
                                        
                                        Text(style.category.rawValue.uppercased())
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Theme.champagneGold)
                                            .tracking(2.0)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                        .stroke(Theme.goldGradient, lineWidth: 1.5)
                                )
                        }
                        .padding(.horizontal)
                        
                        // Title & Description
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(style.name)
                                    .font(Theme.holidayTitle(size: 24))
                                    .foregroundColor(Theme.snowWhite)
                                Spacer()
                                Text(style.tag)
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.velvetCrimson)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                            
                            Text(style.description)
                                .font(Theme.holidayBody(size: 15))
                                .foregroundColor(Theme.parchment)
                                .lineSpacing(3)
                        }
                        .padding(.horizontal)
                        
                        // Recommended Photo Tip Card
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(Theme.gold)
                                    Text("RECOMMENDED REFERENCE PHOTO")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                }
                                
                                Text(style.recommendedPhotoTip)
                                    .font(Theme.holidayBody(size: 13))
                                    .foregroundColor(Theme.parchment)
                            }
                        }
                        .padding(.horizontal)
                        
                        // AI Prompt Transparency Card
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "wand.and.stars")
                                        .foregroundColor(Theme.gold)
                                    Text("AI PROMPT BLUEPRINT")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                }
                                
                                Text(style.basePrompt)
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(Theme.parchment.opacity(0.85))
                                    .lineSpacing(2)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Action Button
                        FestiveButton("Use This Christmas Style", systemImage: "sparkles", style: .gold) {
                            dismiss()
                            onStartWithStyle()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Style Inspiration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.champagneGold)
                }
            }
        }
    }
}

public struct StyleSelectionView: View {
    @State private var selectedCategory: StyleCategory = .santaLook
    @State private var selectedStyleForDetail: ChristmasStyle?
    @State private var styleToLaunch: ChristmasStyle?
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                if AppState.shared.isSnowEnabled {
                    SnowfallEffectView(flakeCount: 20)
                }
                
                VStack(spacing: 12) {
                    // Category Picker Horizontal Strip
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(StyleCategory.allCases) { cat in
                                Button(action: {
                                    selectedCategory = cat
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: cat.systemIcon)
                                            .font(.system(size: 13))
                                        Text(cat.rawValue)
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategory == cat ? Theme.velvetGradient : LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .top, endPoint: .bottom))
                                            .overlay(
                                                Capsule()
                                                    .stroke(selectedCategory == cat ? Theme.gold : Color.white.opacity(0.12), lineWidth: 1)
                                            )
                                    )
                                    .foregroundColor(selectedCategory == cat ? .white : Theme.parchment)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    
                    // Category Subtitle
                    Text(selectedCategory.subtitle)
                        .font(Theme.holidayBody(size: 12))
                        .foregroundColor(Theme.champagneGold.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Styles Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 14) {
                            let styles = ChristmasStyle.allStyles.filter { $0.category == selectedCategory }
                            ForEach(styles) { style in
                                StyleCardView(style: style, isSelected: false) {
                                    selectedStyleForDetail = style
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Christmas Styles")
            .sheet(item: $selectedStyleForDetail) { style in
                StyleDetailSheet(style: style) {
                    styleToLaunch = style
                }
            }
            .sheet(item: $styleToLaunch) { style in
                let vm = GenerationViewModel(style: style)
                PhotoPickerAndPreviewView(viewModel: vm)
            }
        }
    }
}
