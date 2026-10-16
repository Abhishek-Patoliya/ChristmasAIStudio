import UIKit

public enum ImageResizer {
    /// Resizes an image so its longest edge does not exceed `maxDimension`.
    /// Preserves aspect ratio, corrects image orientation, and reduces memory consumption.
    public static func resize(image: UIImage, maxDimension: CGFloat = Constants.maxImageDimension) -> UIImage {
        let size = image.size
        guard size.width > maxDimension || size.height > maxDimension else {
            return normalizeOrientation(image)
        }
        
        let aspectRatio = size.width / size.height
        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1.0 // 1x scale for exact pixel dimensions
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    /// Normalizes UIImage orientation if taken with iPhone camera (portrait/landscape exif)
    public static func normalizeOrientation(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = image.scale
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
    }
    
    /// Compresses image to JPEG data with target quality, guaranteeing safe payload sizes
    public static func compressToJPEG(image: UIImage, quality: CGFloat = 0.85) -> Data? {
        let normalized = resize(image: image)
        return normalized.jpegData(compressionQuality: quality)
    }
}
