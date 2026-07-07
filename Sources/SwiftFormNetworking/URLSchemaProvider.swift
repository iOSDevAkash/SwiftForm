import SwiftFormCore
import SwiftFormSchema
import SwiftFormJSON
import Foundation

/// Fetches form schemas from a URL endpoint.
public struct URLSchemaProvider: SchemaProvider, Sendable {

    private let session: URLSession
    private let decoder: JSONSchemaDecoder
    private let timeoutInterval: TimeInterval

    public init(
        session: URLSession = .shared,
        timeoutInterval: TimeInterval = 30
    ) {
        self.session = session
        self.decoder = JSONSchemaDecoder()
        self.timeoutInterval = timeoutInterval
    }

    public func fetchSchema(
        id: String,
        cachePolicy: CachePolicy
    ) async throws -> any FormSchema {
        guard let url = URL(string: id) else {
            throw FormError.networkError(reason: "Invalid URL: \(id)")
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval

        switch cachePolicy {
        case .never:
            request.cachePolicy = .reloadIgnoringLocalCacheData
        case .memory:
            request.cachePolicy = .returnCacheDataElseLoad
        case .disk:
            request.cachePolicy = .returnCacheDataElseLoad
        case .custom:
            break
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw FormError.networkError(reason: "Request failed: \(error.localizedDescription)")
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FormError.networkError(reason: "Invalid response type")
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw FormError.networkError(
                reason: "HTTP \(httpResponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
            )
        }

        return try decoder.decode(from: data)
    }
}
