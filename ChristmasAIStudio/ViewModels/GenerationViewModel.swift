import SwiftUI
import PhotosUI
import Combine

public enum GenerationState: Equatable {
    case idle
    case preparing
    case generating(progress: Double, step: String)
    case success(GeneratedImage)
    case failure(String)
    
    public static func == (lhs: GenerationState, rhs: GenerationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.preparing, .preparing):
            return true
        case (.generating(let p1, let s1), .generating(let p2, let s2)):
            return p1 == p2 && s1 == s2
        case (.success(let img1), .success(let img2)):
            return img1.id == img2.id
        case (.failure(let e1), .failure(let e2)):
            return e1 == e2
        default:
            return false
        }
    }
}

@MainActor
public final class GenerationViewModel: ObservableObject {
    @Published public var selectedStyle: ChristmasStyle
    @Published public var selectedPickerItem: PhotosPickerItem? = nil {
        didSet {
            Task { await loadSelectedPhoto() }
        }
    }
    @Published public var referenceImage: UIImage?
    @Published public var state: GenerationState = .idle
    @Published public var errorMessage: String?
    @Published public var showComparison: Bool = false
    @Published public var showCardEditor: Bool = false
    @Published public var showPaywall: Bool = false
    @Published public var saveSuccessToast: Bool = false
    
    private let generationService: ImageGenerationServiceProtocol
    private let storageService: StorageService
    private let photoLibraryService: PhotoLibraryService
    
    public init(
        style: ChristmasStyle,
        generationService: ImageGenerationServiceProtocol = ImageGenerationService.shared,
        storageService: StorageService = StorageService.shared,
        photoLibraryService: PhotoLibraryService = PhotoLibraryService.shared
    ) {
        self.selectedStyle = style
        self.generationService = generationService
        self.storageService = storageService
        self.photoLibraryService = photoLibraryService
    }
    
    // MARK: - Load Selected Photo from PhotosPicker
    public func loadSelectedPhoto() async {
        guard let selectedPickerItem else { return }
        
        do {
            if let data = try await selectedPickerItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let normalized = ImageResizer.normalizeOrientation(image)
                self.referenceImage = normalized
                self.errorMessage = nil
            } else {
                self.errorMessage = "Could not load selected photo format. Please try another photo."
            }
        } catch {
            self.errorMessage = "Error loading image: \(error.localizedDescription)"
        }
    }
    
    public func setCustomReferenceImage(_ image: UIImage) {
        self.referenceImage = ImageResizer.normalizeOrientation(image)
        self.errorMessage = nil
    }
    
    // MARK: - Start AI Generation
    public func startGeneration() async {
        guard let referenceImage else {
            errorMessage = "Please select or take a photo first."
            return
        }
        
        // Verify user has credits or active Pro subscription
        if !storageService.creditBalance.canGenerate {
            showPaywall = true
            return
        }
        
        errorMessage = nil
        state = .generating(progress: 0.05, step: "Preparing holiday photo...")
        
        do {
            let generated = try await generationService.generateChristmasPhoto(
                referenceImage: referenceImage,
                style: selectedStyle
            ) { [weak self] progress, step in
                guard let self else { return }
                self.state = .generating(progress: progress, step: step)
            }
            
            // Persist creation locally
            storageService.saveCreation(generated)
            self.state = .success(generated)
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch let apiError as APIError {
            if case .cancelled = apiError {
                self.state = .idle
            } else {
                self.state = .failure(apiError.localizedDescription)
                self.errorMessage = apiError.localizedDescription
            }
        } catch {
            self.state = .failure(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Cancel Generation
    public func cancelGeneration() {
        generationService.cancelGeneration()
        state = .idle
    }
    
    // MARK: - Save Result to Camera Roll
    public func saveResultToPhotos(image: UIImage) async {
        do {
            try await photoLibraryService.saveImageToLibrary(image)
            self.saveSuccessToast = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
