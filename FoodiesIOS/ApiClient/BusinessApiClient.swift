import SwiftHttp
import SwiftUI

struct BusinessApiClient: ApiClient {
    let httpClient: HttpClient
    let baseUrl: HttpUrl
    let basePath = "businesses"

    func getBusinesses(
        center: Locatable,
        distance: Double
    ) async throws
        -> BusinessListingModel
    {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(basePath)
                .query("latitude", String(center.latitude))
                .query("longitude", String(center.longitude))
                .query("distance", String(Int(distance.rounded()))),
            method: .get
        )
    }

    func getRecommendations(
        center: Locatable,
        distance: Double
    ) async throws
        -> BusinessListingModel
    {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(basePath).path("recommendations")
                .query("latitude", String(center.latitude))
                .query("longitude", String(center.longitude))
                .query("distance", String(Int(distance.rounded()))),
            method: .get
        )
    }

    func getBusiness(business: BusinessModel) async throws -> BusinessModel? {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(basePath, business.id.uuidString),
            method: .get
        )
    }
}
