import Foundation
import UIKit
import Combine

public protocol ImageGenerationServiceProtocol {
    func generateChristmasPhoto(
        referenceImage: UIImage,
        style: ChristmasStyle,
        onProgress: @escaping (Double, String) -> Void
    ) async throws -> GeneratedImage
    
    func cancelGeneration()
}

public final class ImageGenerationService: ImageGenerationServiceProtocol {
    public static let shared = ImageGenerationService()
    
    private let apiService: BackendAPIServiceProtocol
    private var activeTask: Task<GeneratedImage, Error>?
    
    public init(apiService: BackendAPIServiceProtocol = BackendAPIService.shared) {
        self.apiService = apiService
    }
    
    public func cancelGeneration() {
        activeTask?.cancel()
        activeTask = nil
    }
    
    public func generateChristmasPhoto(
        referenceImage: UIImage,
        style: ChristmasStyle,
        onProgress: @escaping (Double, String) -> Void
    ) async throws -> GeneratedImage {
        // Cancel any existing running task
        cancelGeneration()
        
        let task = Task<GeneratedImage, Error> {
            try Task.checkCancellation()
            
            // 1. Optimize & resize reference image
            await MainActor.run { onProgress(0.10, "Preparing reference photo...") }
            let resized = ImageResizer.resize(image: referenceImage)
            guard let jpegData = ImageResizer.compressToJPEG(image: resized, quality: 0.85) else {
                throw APIError.invalidImageData
            }
            
            try Task.checkCancellation()
            
            // Check if mock mode is enabled or backend health
            let forceMock = UserDefaults.standard.bool(forKey: Constants.keyMockMode)
            var useMock = forceMock
            
            if !useMock {
                let isBackendHealthy = await apiService.healthCheck()
                if !isBackendHealthy {
                    // Backend not reachable, fall back to clearly labeled mock preview
                    useMock = true
                }
            }
            
            if useMock {
                return try await executeMockGeneration(
                    referenceImage: referenceImage,
                    referenceJPEG: jpegData,
                    style: style,
                    onProgress: onProgress
                )
            } else {
                return try await executeRealBackendGeneration(
                    referenceJPEG: jpegData,
                    style: style,
                    onProgress: onProgress
                )
            }
        }
        
        self.activeTask = task
        return try await task.value
    }
    
    // MARK: - Mock Generation (Clear Sample Results)
    private func executeMockGeneration(
        referenceImage: UIImage,
        referenceJPEG: Data,
        style: ChristmasStyle,
        onProgress: @escaping (Double, String) -> Void
    ) async throws -> GeneratedImage {
        let steps: [(Double, String, UInt64)] = [
            (0.20, "Uploading photo to holiday studio...", 500_000_000),
            (0.40, "Analyzing facial features & natural lighting...", 600_000_000),
            (0.65, "Rendering \(style.name) attire & textures...", 700_000_000),
            (0.85, "Adding festive fairy lights & holiday ambiance...", 600_000_000),
            (0.98, "Finishing high-res Christmas portrait...", 400_000_000)
        ]
        
        for step in steps {
            try Task.checkCancellation()
            await MainActor.run { onProgress(step.0, step.1) }
            try await Task.sleep(nanoseconds: step.2)
        }
        
        try Task.checkCancellation()
        
        let sampleImage = MockImageGenerator.generateSampleFestiveImage(
            for: style,
            originalImage: referenceImage
        )
        guard let sampleJPEG = sampleImage.jpegData(compressionQuality: 0.90) else {
            throw APIError.invalidImageData
        }
        
        await MainActor.run { onProgress(1.0, "Ready!") }
        
        return GeneratedImage(
            styleId: style.id,
            styleName: style.name,
            categoryName: style.category.rawValue,
            promptUsed: style.basePrompt,
            originalPhotoData: referenceJPEG,
            generatedImageData: sampleJPEG,
            isFavorite: false,
            isMock: true,
            note: "Generated in Mock Mode (Sample Preview)"
        )
    }
    
    // MARK: - Real Backend Generation
    private func executeRealBackendGeneration(
        referenceJPEG: Data,
        style: ChristmasStyle,
        onProgress: @escaping (Double, String) -> Void
    ) async throws -> GeneratedImage {
        await MainActor.run { onProgress(0.25, "Uploading photo to secure AI server...") }
        
        let request = GenerationRequest(
            styleId: style.id,
            styleName: style.name,
            prompt: style.basePrompt,
            negativePrompt: style.negativePrompt
        )
        
        let job = try await apiService.submitGeneration(request: request, imageJPEG: referenceJPEG)
        
        // Poll for job completion with timeout
        var currentJob = job
        let pollInterval: UInt64 = 1_500_000_000 // 1.5s
        let maxAttempts = 40 // up to 60s
        var attempts = 0
        
        while !currentJob.status.isTerminal && attempts < maxAttempts {
            try Task.checkCancellation()
            try await Task.sleep(nanoseconds: pollInterval)
            attempts += 1
            
            currentJob = try await apiService.checkJobStatus(jobId: currentJob.id)
            let progress = min(0.90, 0.30 + (Double(attempts) / Double(maxAttempts)) * 0.60)
            await MainActor.run {
                onProgress(progress, currentJob.stepDescription)
            }
        }
        
        try Task.checkCancellation()
        
        guard currentJob.status == .completed else {
            if attempts >= maxAttempts {
                throw APIError.timeout
            }
            throw APIError.jobFailed(currentJob.error ?? "Generation failed on server")
        }
        
        guard let urlString = currentJob.resultImageURL, let imageURL = URL(string: urlString) else {
            throw APIError.jobFailed("Missing resulting image URL")
        }
        
        await MainActor.run { onProgress(0.95, "Downloading high-resolution portrait...") }
        let resultData = try await apiService.fetchResultImage(from: imageURL)
        
        await MainActor.run { onProgress(1.0, "Complete!") }
        
        return GeneratedImage(
            styleId: style.id,
            styleName: style.name,
            categoryName: style.category.rawValue,
            promptUsed: style.basePrompt,
            originalPhotoData: referenceJPEG,
            generatedImageData: resultData,
            isFavorite: false,
            isMock: false
        )
    }
}
