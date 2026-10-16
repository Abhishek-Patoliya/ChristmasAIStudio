import SwiftUI

public enum ComparisonMode: String, CaseIterable, Identifiable {
    case slider = "Interactive Split"
    case sideBySide = "Side by Side"
    
    public var id: String { rawValue }
}

public struct BeforeAfterComparisonView: View {
    let beforeImage: UIImage
    let afterImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var comparisonMode: ComparisonMode = .slider
    
    public init(beforeImage: UIImage, afterImage: UIImage) {
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Theme.holidayBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Mode Selector
                    Picker("Mode", selection: $comparisonMode) {
                        ForEach(ComparisonMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Comparison Canvas
                    if comparisonMode == .slider {
                        BeforeAfterSlider(beforeImage: beforeImage, afterImage: afterImage)
                            .padding(.horizontal)
                            .frame(maxHeight: 520)
                        
                        Text("Drag the golden divider left and right to compare")
                            .font(Theme.holidayBody(size: 13))
                            .foregroundColor(Theme.parchment.opacity(0.7))
                    } else {
                        // Side-by-Side Scrollable
                        ScrollView {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("ORIGINAL REFERENCE")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.champagneGold)
                                    Image(uiImage: beforeImage)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(Theme.cornerRadiusMedium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("CHRISTMAS AI STUDIO")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.gold)
                                    Image(uiImage: afterImage)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(Theme.cornerRadiusMedium)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                                                .stroke(Theme.goldGradient, lineWidth: 1.5)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Before & After")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.champagneGold)
                }
            }
        }
    }
}
