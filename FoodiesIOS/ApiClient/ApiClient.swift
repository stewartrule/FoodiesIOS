import SwiftHttp
import Foundation

protocol ApiClient: HttpCodablePipelineCollection {
    var httpClient: HttpClient { get }
}

extension ApiClient {
    func decoder<T: Decodable>() -> HttpResponseDecoder<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return .json(decoder)
    }

    func decodableRequests<T: Codable>(urls: [HttpUrl]) async throws -> [T] {
        return try await withThrowingTaskGroup(of: T?.self) { group in
            for url in urls {
                group.addTask {
                    do {
                        return try await decodableRequest(
                            executor: httpClient.dataTask,
                            url: url,
                            method: .get
                        )
                    }
                    catch { print(error) }
                    return nil
                }
            }

            return try await group.reduce(into: []) { models, model in
                models.append(model)
            }
        }
        .compactMap({ $0 })
    }
}
