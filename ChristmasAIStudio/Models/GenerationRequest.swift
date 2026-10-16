import Foundation

public struct GenerationRequest: Codable, Identifiable {
    public let id: UUID
    public let styleId: String
    public let styleName: String
    public let prompt: String
    public let negativePrompt: String
    public let timestamp: Date
    public let clientVersion: String
    public var highFidelityMode: Bool
    
    public init(
        id: UUID = UUID(),
        styleId: String,
        styleName: String,
        prompt: String,
        negativePrompt: String,
        timestamp: Date = Date(),
        clientVersion: String = "1.0.0",
        highFidelityMode: Bool = true
    ) {
        self.id = id
        self.styleId = styleId
        self.styleName = styleName
        self.prompt = prompt
        self.negativePrompt = negativePrompt
        self.timestamp = timestamp
        self.clientVersion = clientVersion
        self.highFidelityMode = highFidelityMode
    }
}

public enum JobStatus: String, Codable {
    case queued = "queued"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case cancelled = "cancelled"
    
    public var isTerminal: Bool {
        self == .completed || self == .failed || self == .cancelled
    }
}

public struct GenerationJob: Codable, Identifiable {
    public let id: String
    public var status: JobStatus
    public var progress: Double
    public var stepDescription: String
    public var resultImageURL: String?
    public var error: String?
    public let createdAt: Date
    public var completedAt: Date?
    public var isMock: Bool
    
    public init(
        id: String = UUID().uuidString,
        status: JobStatus = .queued,
        progress: Double = 0.05,
        stepDescription: String = "Uploading holiday reference photo...",
        resultImageURL: String? = nil,
        error: String? = nil,
        createdAt: Date = Date(),
        completedAt: Date? = nil,
        isMock: Bool = false
    ) {
        self.id = id
        self.status = status
        self.progress = progress
        self.stepDescription = stepDescription
        self.resultImageURL = resultImageURL
        self.error = error
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.isMock = isMock
    }
}
