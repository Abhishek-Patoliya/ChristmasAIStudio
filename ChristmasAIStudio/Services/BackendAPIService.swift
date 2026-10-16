import Foundation
import UIKit

public enum APIError: LocalizedError {
    case invalidURL
    case networkUnavailable
    case serverError(statusCode: Int, message: String)
    case decodingFailed
    case jobFailed(String)
    case timeout
    case cancelled
    case invalidImageData
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The backend server URL is invalid. Please check your settings."
        case .networkUnavailable:
            return "No internet connection detected. Please verify your connection."
        case .serverError(let code, let msg):
            return "Backend service error (\(code)): \(msg)"
        case .decodingFailed:
            return "Failed to parse the server response."
        case .jobFailed(let reason):
            return "Holiday image generation failed: \(reason)"
        case .timeout:
            return "The AI generation request timed out. Please try again."
        case .cancelled:
            return "Generation was cancelled by the user."
        case .invalidImageData:
            return "The selected photo could not be prepared for AI generation."
        }
    }
}

public protocol BackendAPIServiceProtocol {
    var baseURL: URL { get }
    func healthCheck() async -> Bool
    func submitGeneration(request: GenerationRequest, imageJPEG: Data) async throws -> GenerationJob
    func checkJobStatus(jobId: String) async throws -> GenerationJob
    func fetchResultImage(from url: URL) async throws -> Data
}

public final class BackendAPIService: BackendAPIServiceProtocol {
    public static let shared = BackendAPIService()
    private let urlSession: URLSession
    
    public init(session: URLSession = .shared) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 45
        config.timeoutIntervalForResource = 120
        self.urlSession = URLSession(configuration: config)
    }
    
    public var baseURL: URL {
        if let customString = UserDefaults.standard.string(forKey: Constants.keyBackendURL),
           let url = URL(string: customString), !customString.trimmingCharacters(in: .whitespaces).isEmpty {
            return url
        }
        return URL(string: Constants.defaultBackendURL)!
    }
    
    public func healthCheck() async -> Bool {
        let endpoint = baseURL.appendingPathComponent("api/health")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.timeoutInterval = 4
        
        do {
            let (_, response) = try await urlSession.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    public func submitGeneration(request: GenerationRequest, imageJPEG: Data) async throws -> GenerationJob {
        let endpoint = baseURL.appendingPathComponent("api/generate")
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var body = Data()
        
        // Style ID
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"styleId\"\r\n\r\n")
        body.appendString("\(request.styleId)\r\n")
        
        // Prompt
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"prompt\"\r\n\r\n")
        body.appendString("\(request.prompt)\r\n")
        
        // Negative Prompt
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"negativePrompt\"\r\n\r\n")
        body.appendString("\(request.negativePrompt)\r\n")
        
        // Image File
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"photo.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageJPEG)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        urlRequest.httpBody = body
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch let err as URLError where err.code == .cancelled {
            throw APIError.cancelled
        } catch let err as URLError where err.code == .timedOut {
            throw APIError.timeout
        } catch {
            throw APIError.networkUnavailable
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError(statusCode: 0, message: "Invalid response from server")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown server error"
            throw APIError.serverError(statusCode: httpResponse.statusCode, message: errorMsg)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(GenerationJob.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
    
    public func checkJobStatus(jobId: String) async throws -> GenerationJob {
        let endpoint = baseURL.appendingPathComponent("api/jobs").appendingPathComponent(jobId)
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.jobFailed("Failed to fetch job status")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(GenerationJob.self, from: data)
    }
    
    public func fetchResultImage(from url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(statusCode: 500, message: "Could not download resulting holiday image")
        }
        return data
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
