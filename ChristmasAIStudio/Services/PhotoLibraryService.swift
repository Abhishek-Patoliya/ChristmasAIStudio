import UIKit
import Photos

public enum PhotoLibraryError: LocalizedError {
    case permissionDenied
    case saveFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Photo Library permission is required to save your festive Christmas portrait. Please enable it in iOS Settings."
        case .saveFailed(let reason):
            return "Failed to save photo to library: \(reason)"
        }
    }
}

public final class PhotoLibraryService {
    public static let shared = PhotoLibraryService()
    
    private init() {}
    
    public func saveImageToLibrary(_ image: UIImage) async throws {
        let status = await requestAddOnlyAuthorization()
        
        guard status == .authorized || status == .limited else {
            throw PhotoLibraryError.permissionDenied
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: PhotoLibraryError.saveFailed(error?.localizedDescription ?? "Unknown error"))
                }
            }
        }
    }
    
    public func requestAddOnlyAuthorization() async -> PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        } else {
            return await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
        }
    }
}
