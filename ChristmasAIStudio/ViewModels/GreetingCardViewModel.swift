import SwiftUI
import Combine

@MainActor
public final class GreetingCardViewModel: ObservableObject {
    @Published public var selectedImage: UIImage
    @Published public var config: GreetingCardConfig
    @Published public var isExporting: Bool = false
    @Published public var exportSuccessToast: Bool = false
    @Published public var errorMessage: String?
    @Published public var showShareSheet: Bool = false
    @Published public var renderedCardImage: UIImage?
    
    private let photoLibraryService: PhotoLibraryService
    
    public init(
        image: UIImage,
        config: GreetingCardConfig = GreetingCardConfig(),
        photoLibraryService: PhotoLibraryService = PhotoLibraryService.shared
    ) {
        self.selectedImage = image
        self.config = config
        self.photoLibraryService = photoLibraryService
    }
    
    public func selectTheme(_ theme: CardDesignTheme) {
        self.config.designTheme = theme
    }
    
    public func selectFontStyle(_ fontStyle: CardFontStyle) {
        self.config.fontStyle = fontStyle
    }
    
    public func selectPlacement(_ placement: CardTextPlacement) {
        self.config.textPlacement = placement
    }
    
    public func exportCard(using rendererImage: UIImage) async {
        isExporting = true
        defer { isExporting = false }
        
        do {
            try await photoLibraryService.saveImageToLibrary(rendererImage)
            self.exportSuccessToast = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
