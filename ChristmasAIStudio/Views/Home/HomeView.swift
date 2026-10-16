import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var storage = StorageService.shared
    @State private var styleForPhotoPicker: ChristmasStyle?
    @State private var creationForCardEditor: GeneratedImage?
    @State private var showGreetingCardPicker: Bool = false
    
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
                    SnowfallEffectView(flakeCount: 25)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Top Hero Holiday Banner
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.forestGreen, Theme.velvetCrimson],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 190)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                                        .stroke(Theme.goldGradient, lineWidth: 1.5)
                                )
                                .shadow(color: Theme.christmasRed.opacity(0.35), radius: 12)
                            
                            // Background sparkles illustration
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 70, weight: .light))
                                        .foregroundColor(Theme.champagneGold.opacity(0.25))
                                        .padding(.trailing, 20)
                                        .padding(.top, 16)
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "wand.and.stars")
                                        .foregroundColor(Theme.gold)
                                    Text("HOLIDAY SEASON 2026")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                        .tracking(1.5)
                                }
                                
                                Text("Turn Any Photo Into Christmas Magic")
                                    .font(Theme.holidayTitle(size: 20))
                                    .foregroundColor(Theme.snowWhite)
                                    .lineLimit(2)
                                
                                Button(action: {
                                    styleForPhotoPicker = ChristmasStyle.allStyles.first
                                }) {
                                    HStack(spacing: 6) {
                                        Text("Create Portrait Now")
                                            .font(.system(size: 13, weight: .bold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Theme.goldGradient)
                                    .foregroundColor(Color(red: 0.15, green: 0.10, blue: 0.05))
                                    .cornerRadius(Theme.cornerRadiusPill)
                                    .shadow(color: Theme.gold.opacity(0.4), radius: 6)
                                }
                                .padding(.top, 4)
                            }
                            .padding(20)
                        }
                        .padding(.horizontal)
                        
                        // Categories Strip
                        VStack(alignment: .leading, spacing: 10) {
                            Text("EXPLORE CATEGORIES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.champagneGold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(StyleCategory.allCases) { cat in
                                        Button(action: {
                                            viewModel.selectCategory(cat)
                                        }) {
                                            HStack(spacing: 6) {
                                                Image(systemName: cat.systemIcon)
                                                    .font(.system(size: 13))
                                                Text(cat.rawValue)
                                                    .font(.system(size: 13, weight: .semibold))
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 9)
                                            .background(
                                                Capsule()
                                                    .fill(viewModel.selectedCategory == cat ? Theme.velvetGradient : LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .top, endPoint: .bottom))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(viewModel.selectedCategory == cat ? Theme.gold : Color.white.opacity(0.12), lineWidth: 1)
                                                    )
                                            )
                                            .foregroundColor(viewModel.selectedCategory == cat ? .white : Theme.parchment)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Category Styles Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(viewModel.selectedCategory.rawValue.uppercased())
                                    .font(.system(size: 14, weight: .bold, design: .serif))
                                    .foregroundColor(Theme.snowWhite)
                                Spacer()
                                NavigationLink(destination: StyleSelectionView()) {
                                    Text("See All")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Theme.champagneGold)
                                }
                            }
                            .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(viewModel.stylesForSelectedCategory) { style in
                                    StyleCardView(style: style) {
                                        styleForPhotoPicker = style
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Recent Creations Horizontal Strip
                        if !storage.savedCreations.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("RECENT CREATIONS")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                    Spacer()
                                    Text("\(storage.savedCreations.count) saved")
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.parchment.opacity(0.6))
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(storage.savedCreations.prefix(6)) { creation in
                                            if let img = creation.uiImage {
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 14)
                                                            .stroke(Theme.gold.opacity(0.4), lineWidth: 1)
                                                    )
                                                    .onTapGesture {
                                                        creationForCardEditor = creation
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Festive Greeting Card Studio Spotlight
                        FestiveCard(highlighted: true) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Theme.lightPine.opacity(0.4))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "envelope.badge.fill")
                                        .font(.system(size: 26))
                                        .foregroundStyle(Theme.goldGradient)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Holiday Greeting Card Maker")
                                        .font(Theme.holidayHeadline(size: 16))
                                        .foregroundColor(Theme.snowWhite)
                                    Text("Turn your portraits into personalized printable holiday cards.")
                                        .font(Theme.holidayBody(size: 12))
                                        .foregroundColor(Theme.parchment.opacity(0.8))
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            if let firstCreation = storage.savedCreations.first {
                                creationForCardEditor = firstCreation
                            } else {
                                styleForPhotoPicker = ChristmasStyle.allStyles.first
                            }
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Christmas AI Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CreditBadgeView {
                        viewModel.showPaywall = true
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.champagneGold)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showPaywall) {
                StorePaywallView()
            }
            .sheet(isPresented: $viewModel.showSettings) {
                SettingsView()
            }
            .sheet(item: $styleForPhotoPicker) { style in
                let genVM = GenerationViewModel(style: style)
                PhotoPickerAndPreviewView(viewModel: genVM)
            }
            .sheet(item: $creationForCardEditor) { creation in
                if let img = creation.uiImage {
                    GreetingCardEditorView(image: img)
                }
            }
        }
    }
}
