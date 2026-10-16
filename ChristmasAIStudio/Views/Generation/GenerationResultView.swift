import SwiftUI

public struct GenerationResultView: View {
    let generatedImage: GeneratedImage
    @ObservedObject var viewModel: GenerationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet: Bool = false
    @State private var showCardEditor: Bool = false
    @State private var showComparison: Bool = false
    
    public init(generatedImage: GeneratedImage, viewModel: GenerationViewModel) {
        self.generatedImage = generatedImage
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                if AppState.shared.isSnowEnabled {
                    SnowfallEffectView(flakeCount: 25)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Result Image Preview Container
                        if let uiImage = generatedImage.uiImage {
                            ZStack(alignment: .bottom) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                            .stroke(Theme.goldGradient, lineWidth: 2)
                                    )
                                    .shadow(color: Theme.gold.opacity(0.35), radius: 15)
                                
                                // Mock Mode Label (Transparent & Honest)
                                if generatedImage.isMock {
                                    HStack(spacing: 6) {
                                        Image(systemName: "wrench.and.screwdriver.fill")
                                        Text("Sample Preview Mode (Mock API)")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.black.opacity(0.8))
                                    .foregroundColor(Theme.champagneGold)
                                    .cornerRadius(Theme.cornerRadiusPill)
                                    .overlay(Capsule().stroke(Theme.gold.opacity(0.6), lineWidth: 1))
                                    .padding(.bottom, 12)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Style Badge & Timestamp
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(generatedImage.styleName)
                                    .font(Theme.holidayHeadline(size: 20))
                                    .foregroundColor(Theme.snowWhite)
                                
                                Text(generatedImage.categoryName)
                                    .font(Theme.holidayBody(size: 13))
                                    .foregroundColor(Theme.champagneGold)
                            }
                            Spacer()
                            
                            Button(action: {
                                StorageService.shared.toggleFavorite(for: generatedImage.id)
                            }) {
                                Image(systemName: generatedImage.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 22))
                                    .foregroundColor(generatedImage.isFavorite ? Theme.brightBerry : Theme.parchment)
                                    .padding(8)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Primary Action Grid
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                // Save to Photos
                                FestiveButton("Save to Photos", systemImage: "arrow.down.circle.fill", style: .gold) {
                                    if let uiImage = generatedImage.uiImage {
                                        Task { await viewModel.saveResultToPhotos(image: uiImage) }
                                    }
                                }
                                
                                // Native Share
                                if let uiImage = generatedImage.uiImage {
                                    ShareLink(
                                        item: Image(uiImage: uiImage),
                                        preview: SharePreview(
                                            "Holiday 2026 Portrait - \(generatedImage.styleName)",
                                            image: Image(uiImage: uiImage)
                                        )
                                    ) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "square.and.arrow.up")
                                            Text("Share")
                                                .font(Theme.holidayHeadline(size: 16))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 15)
                                        .background(Theme.velvetGradient)
                                        .foregroundColor(.white)
                                        .cornerRadius(Theme.cornerRadiusMedium)
                                        .shadow(color: Theme.christmasRed.opacity(0.3), radius: 6)
                                    }
                                }
                            }
                            
                            // Create Greeting Card Action
                            FestiveButton(
                                "Create Christmas Greeting Card",
                                systemImage: "envelope.badge.fill",
                                style: .glass
                            ) {
                                showCardEditor = true
                            }
                            
                            // Before / After Comparison Action
                            if generatedImage.originalPhotoData != nil {
                                Button(action: {
                                    showComparison = true
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.left.and.right.square.fill")
                                            .foregroundColor(Theme.gold)
                                        Text("Compare Before & After")
                                            .font(Theme.holidayHeadline(size: 15))
                                            .foregroundColor(Theme.champagneGold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                            .stroke(Theme.gold.opacity(0.4), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Your Holiday Portrait")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        viewModel.state = .idle
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
            }
            .sheet(isPresented: $showCardEditor) {
                if let uiImage = generatedImage.uiImage {
                    GreetingCardEditorView(image: uiImage)
                }
            }
            .sheet(isPresented: $showComparison) {
                if let originalData = generatedImage.originalPhotoData,
                   let originalImage = UIImage(data: originalData),
                   let afterImage = generatedImage.uiImage {
                    BeforeAfterComparisonView(beforeImage: originalImage, afterImage: afterImage)
                }
            }
            .overlay(alignment: .top) {
                if viewModel.saveSuccessToast {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.gold)
                        Text("Saved to Photos successfully!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(Theme.cornerRadiusPill)
                    .overlay(Capsule().stroke(Theme.gold.opacity(0.5), lineWidth: 1))
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                viewModel.saveSuccessToast = false
                            }
                        }
                    }
                }
            }
        }
    }
}
