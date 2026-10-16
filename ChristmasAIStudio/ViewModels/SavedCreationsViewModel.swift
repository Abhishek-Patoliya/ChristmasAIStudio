import SwiftUI
import Combine

@MainActor
public final class SavedCreationsViewModel: ObservableObject {
    @Published public var showFavoritesOnly: Bool = false
    @Published public var selectedCategoryFilter: StyleCategory? = nil
    @Published public var selectedCreationForDetail: GeneratedImage?
    @Published public var creationForCardEditor: GeneratedImage?
    @Published public var showPaywall: Bool = false
    
    private let storage: StorageService
    
    public init(storage: StorageService = StorageService.shared) {
        self.storage = storage
    }
    
    public var creations: [GeneratedImage] {
        storage.savedCreations.filter { creation in
            if showFavoritesOnly && !creation.isFavorite {
                return false
            }
            if let filter = selectedCategoryFilter, creation.categoryName != filter.rawValue {
                return false
            }
            return true
        }
    }
    
    public func toggleFavorite(id: UUID) {
        storage.toggleFavorite(for: id)
    }
    
    public func delete(id: UUID) {
        storage.deleteCreation(id: id)
    }
}
