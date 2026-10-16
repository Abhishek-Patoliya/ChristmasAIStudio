import SwiftUI

public struct SavedCreationDetailView: View {
    let creation: GeneratedImage
    @ObservedObject var viewModel: SavedCreationsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCardEditor: Bool = false
    @State private var showComparison: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var saveSuccessToast: Bool = false
    
    public init(creation: GeneratedImage, viewModel: SavedCreationsViewModel) {
        self.creation = creation
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let uiImage = creation.uiImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(Theme.cornerRadiusLarge)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                        .stroke(Theme.goldGradient, lineWidth: 2)
                                )
                                .shadow(color: Theme.gold.opacity(0.3), radius: 12)
                                .padding(.horizontal)
                        }
                        
                        // Metadata Card
                        FestiveCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(creation.styleName)
                                            .font(Theme.holidayHeadline(size: 20))
                                            .foregroundColor(Theme.snowWhite)
                                        
                                        Text(creation.categoryName)
                                            .font(Theme.holidayBody(size: 13))
                                            .foregroundColor(Theme.champagneGold)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.toggleFavorite(id: creation.id)
                                    }) {
                                        Image(systemName: creation.isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 24))
                                            .foregroundColor(creation.isFavorite ? Theme.brightBerry : Theme.parchment)
                                    }
                                }
                                
                                Divider().background(Color.white.opacity(0.1))
                                
                                Text("Created: \(creation.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.parchment.opacity(0.6))
                                
                                if creation.isMock {
                                    Text("Mode: Mock Development Sample")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                FestiveButton("Save to Photos", systemImage: "arrow.down.circle.fill", style: .gold) {
                                    if let img = creation.uiImage {
                                        Task {
                                            try? await PhotoLibraryService.shared.saveImageToLibrary(img)
                                            saveSuccessToast = true
                                        }
                                    }
                                }
                                
                                if let img = creation.uiImage {
                                    ShareLink(item: Image(uiImage: img), preview: SharePreview(creation.styleName, image: Image(uiImage: img))) {
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
                                    }
                                }
                            }
                            
                            FestiveButton("Design Holiday Greeting Card", systemImage: "envelope.badge.fill", style: .glass) {
                                showCardEditor = true
                            }
                            
                            if creation.originalPhotoData != nil {
                                Button(action: {
                                    showComparison = true
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.left.and.right.square.fill")
                                            .foregroundColor(Theme.gold)
                                        Text("Before & After Comparison")
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
                            
                            // Delete Button
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "trash")
                                    Text("Delete Creation")
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.brightBerry)
                                .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Creation Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
            }
            .sheet(isPresented: $showCardEditor) {
                if let img = creation.uiImage {
                    GreetingCardEditorView(image: img)
                }
            }
            .sheet(isPresented: $showComparison) {
                if let origData = creation.originalPhotoData,
                   let orig = UIImage(data: origData),
                   let gen = creation.uiImage {
                    BeforeAfterComparisonView(beforeImage: orig, afterImage: gen)
                }
            }
            .alert("Delete Creation?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.delete(id: creation.id)
                    dismiss()
                }
            } message: {
                Text("This holiday portrait will be permanently removed from your saved gallery.")
            }
            .overlay(alignment: .top) {
                if saveSuccessToast {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Theme.gold)
                        Text("Saved to Photos!").font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(Theme.cornerRadiusPill)
                    .overlay(Capsule().stroke(Theme.gold.opacity(0.5), lineWidth: 1))
                    .padding(.top, 16)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation { saveSuccessToast = false }
                        }
                    }
                }
            }
        }
    }
}

public struct SavedCreationsView: View {
    @StateObject private var viewModel = SavedCreationsViewModel()
    
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
                    // Filter bar
                    HStack(spacing: 8) {
                        // Favorites Only Toggle
                        Button(action: {
                            viewModel.showFavoritesOnly.toggle()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                                Text("Favorites")
                            }
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(viewModel.showFavoritesOnly ? Theme.velvetCrimson : Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(Theme.cornerRadiusPill)
                        }
                        
                        // Category Filter Menu
                        Menu {
                            Button("All Categories") {
                                viewModel.selectedCategoryFilter = nil
                            }
                            ForEach(StyleCategory.allCases) { cat in
                                Button(cat.rawValue) {
                                    viewModel.selectedCategoryFilter = cat
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(viewModel.selectedCategoryFilter?.rawValue ?? "All Categories")
                                Image(systemName: "chevron.down")
                            }
                            .font(.system(size: 13, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(Theme.champagneGold)
                            .cornerRadius(Theme.cornerRadiusPill)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    if viewModel.creations.isEmpty {
                        // Empty State
                        VStack(spacing: 16) {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Theme.lightPine.opacity(0.3))
                                    .frame(width: 90, height: 90)
                                Image(systemName: "sparkles.rectangle.stack.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Theme.goldGradient)
                            }
                            
                            Text("No Holiday Creations Yet")
                                .font(Theme.holidayTitle(size: 20))
                                .foregroundColor(Theme.snowWhite)
                            
                            Text("Choose a festive style on Home to create your first Christmas AI portrait!")
                                .font(Theme.holidayBody(size: 14))
                                .foregroundColor(Theme.parchment.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 36)
                            
                            Spacer()
                        }
                    } else {
                        // Creations Grid
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(viewModel.creations) { creation in
                                    Button(action: {
                                        viewModel.selectedCreationForDetail = creation
                                    }) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            ZStack(alignment: .topTrailing) {
                                                if let img = creation.uiImage {
                                                    Image(uiImage: img)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(height: 170)
                                                        .frame(maxWidth: .infinity)
                                                        .clipped()
                                                        .cornerRadius(Theme.cornerRadiusMedium)
                                                }
                                                
                                                if creation.isFavorite {
                                                    Image(systemName: "heart.fill")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Theme.brightBerry)
                                                        .padding(8)
                                                        .background(Circle().fill(Color.black.opacity(0.6)))
                                                        .padding(6)
                                                }
                                            }
                                            
                                            Text(creation.styleName)
                                                .font(Theme.holidayHeadline(size: 14))
                                                .foregroundColor(Theme.snowWhite)
                                                .lineLimit(1)
                                            
                                            Text(creation.categoryName)
                                                .font(Theme.holidayBody(size: 11))
                                                .foregroundColor(Theme.champagneGold)
                                                .lineLimit(1)
                                        }
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                                .fill(Theme.cardSurface)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
            .navigationTitle("Saved Creations")
            .sheet(item: $viewModel.selectedCreationForDetail) { creation in
                SavedCreationDetailView(creation: creation, viewModel: viewModel)
            }
        }
    }
}
