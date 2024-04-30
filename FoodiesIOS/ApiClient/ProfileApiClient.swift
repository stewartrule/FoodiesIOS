import SwiftHttp
import SwiftUI

struct ProfileApiClient: ApiClient {
    let httpClient: HttpClient
    let baseUrl: HttpUrl

    enum Path: String {
        case base = "profile"
        case orders = "orders"
    }

    func getProfile() async throws -> ProfileResponse? {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.base.rawValue),
            method: .get
        )
    }

    func getOrders() async throws -> Page<OrderModel> {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.base.rawValue, Path.orders.rawValue),
            method: .get
        )
    }

    func getOrder(_ order: OrderModel) async throws -> OrderModel {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                Path.orders.rawValue,
                order.id.uuidString
            ),
            method: .get
        )
    }
}
