import SwiftUI
import PhotosUI

public struct PhotoPickerAndPreviewView: View {
    @ObservedObject var viewModel: GenerationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCamera: Bool = false
    
    public init(viewModel: GenerationViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                if AppState.shared.isSnowEnabled {
                    SnowfallEffectView(flakeCount: 20)
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Selected Style Info Card
                        FestiveCard(highlighted: true) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Theme.lightPine.opacity(0.4))
                                        .frame(width: 54, height: 54)
                                    Image(systemName: viewModel.selectedStyle.systemIcon)
                                        .font(.system(size: 24))
                                        .foregroundStyle(Theme.goldGradient)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(viewModel.selectedStyle.name)
                                            .font(Theme.holidayHeadline(size: 18))
                                            .foregroundColor(Theme.snowWhite)
                                        Spacer()
                                        Text(viewModel.selectedStyle.category.rawValue)
                                            .font(.system(size: 10, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 3)
                                            .background(Theme.pineNeedle)
                                            .foregroundColor(Theme.champagneGold)
                                            .cornerRadius(4)
                                    }
                                    
                                    Text(viewModel.selectedStyle.description)
                                        .font(Theme.holidayBody(size: 12))
                                        .foregroundColor(Theme.parchment.opacity(0.8))
                                        .lineLimit(2)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Reference Photo Container / Preview
                        VStack(spacing: 12) {
                            if let referenceImage = viewModel.referenceImage {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: referenceImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 320)
                                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                                .stroke(Theme.goldGradient, lineWidth: 2)
                                        )
                                        .shadow(color: Theme.gold.opacity(0.3), radius: 10)
                                    
                                    // Remove/Change photo button
                                    Button(action: {
                                        viewModel.referenceImage = nil
                                        viewModel.selectedPickerItem = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 26))
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.6)))
                                    }
                                    .padding(12)
                                }
                            } else {
                                // Empty state placeholder for photo picker
                                PhotosPicker(selection: $viewModel.selectedPickerItem, matching: .images) {
                                    VStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white.opacity(0.08))
                                                .frame(width: 80, height: 80)
                                            Image(systemName: "photo.badge.plus")
                                                .font(.system(size: 34, weight: .light))
                                                .foregroundStyle(Theme.goldGradient)
                                        }
                                        
                                        VStack(spacing: 6) {
                                            Text("Choose a Reference Photo")
                                                .font(Theme.holidayHeadline(size: 18))
                                                .foregroundColor(Theme.snowWhite)
                                            Text("Tap to select from your photo library")
                                                .font(Theme.holidayBody(size: 13))
                                                .foregroundColor(Theme.parchment.opacity(0.7))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 280)
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                            .fill(Theme.cardSurface.opacity(0.6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                                    .strokeBorder(
                                                        Theme.gold.opacity(0.4),
                                                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                                                    )
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Photo Guidance Tips
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 6) {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(Theme.gold)
                                    Text("AI Portrait Best Practices")
                                        .font(Theme.holidayHeadline(size: 14))
                                        .foregroundColor(Theme.champagneGold)
                                }
                                
                                Text("• \(viewModel.selectedStyle.recommendedPhotoTip)")
                                    .font(Theme.holidayBody(size: 12))
                                    .foregroundColor(Theme.parchment)
                                
                                Text("• Clear front-facing portraits with even lighting produce the best holiday transformations.")
                                    .font(Theme.holidayBody(size: 12))
                                    .foregroundColor(Theme.parchment.opacity(0.8))
                                
                                Text("• Avoid heavy filters, dark sunglasses, or obstructed faces.")
                                    .font(Theme.holidayBody(size: 12))
                                    .foregroundColor(Theme.parchment.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                        
                        // Error message if any
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(Theme.holidayBody(size: 13))
                                .foregroundColor(Theme.brightBerry)
                                .padding(.horizontal)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            if viewModel.referenceImage != nil {
                                FestiveButton(
                                    "Generate Christmas Portrait",
                                    systemImage: "wand.and.stars",
                                    style: .gold
                                ) {
                                    Task { await viewModel.startGeneration() }
                                }
                            } else {
                                PhotosPicker(selection: $viewModel.selectedPickerItem, matching: .images) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                        Text("Select Photo from Library")
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
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Holiday Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    CreditBadgeView {
                        viewModel.showPaywall = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.showPaywall) {
                StorePaywallView()
            }
            .fullScreenCover(isPresented: Binding(
                get: {
                    if case .generating = viewModel.state { return true }
                    return false
                },
                set: { _ in }
            )) {
                GenerationProgressView(viewModel: viewModel)
            }
            .sheet(isPresented: Binding(
                get: {
                    if case .success = viewModel.state { return true }
                    return false
                },
                set: { isShowing in
                    if !isShowing { viewModel.state = .idle }
                }
            )) {
                if case .success(let generatedImage) = viewModel.state {
                    GenerationResultView(generatedImage: generatedImage, viewModel: viewModel)
                }
            }
        }
    }
}
