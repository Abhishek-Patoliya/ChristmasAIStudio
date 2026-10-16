import Foundation
import UIKit
import SwiftUI

public struct GeneratedImage: Identifiable, Codable, Equatable {
    public let id: UUID
    public let styleId: String
    public let styleName: String
    public let categoryName: String
    public let promptUsed: String
    public let originalPhotoData: Data?
    public let generatedImageData: Data
    public let createdAt: Date
    public var isFavorite: Bool
    public var isMock: Bool
    public var note: String?
    
    public init(
        id: UUID = UUID(),
        styleId: String,
        styleName: String,
        categoryName: String,
        promptUsed: String,
        originalPhotoData: Data?,
        generatedImageData: Data,
        createdAt: Date = Date(),
        isFavorite: Bool = false,
        isMock: Bool = false,
        note: String? = nil
    ) {
        self.id = id
        self.styleId = styleId
        self.styleName = styleName
        self.categoryName = categoryName
        self.promptUsed = promptUsed
        self.originalPhotoData = originalPhotoData
        self.generatedImageData = generatedImageData
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.isMock = isMock
        self.note = note
    }
    
    public var uiImage: UIImage? {
        UIImage(data: generatedImageData)
    }
    
    public var originalUIImage: UIImage? {
        guard let originalPhotoData else { return nil }
        return UIImage(data: originalPhotoData)
    }
    
    public static func == (lhs: GeneratedImage, rhs: GeneratedImage) -> Bool {
        lhs.id == rhs.id && lhs.isFavorite == rhs.isFavorite && lhs.note == rhs.note
    }
}
