import SwiftHttp
import SwiftUI

struct CustomerApiClient: ApiClient {
    let httpClient: HttpClient
    let baseUrl: HttpUrl

    enum Path: String {
        case base = "customers"
        case orders = "orders"
        case chats = "chats"
    }

    func get(customerID: UUID) async throws -> CustomerModel? {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.base.rawValue, customerID.uuidString),
            method: .get
        )
    }

    func getOrders(for customerID: UUID) async throws -> [OrderModel] {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                customerID.uuidString,
                Path.orders.rawValue
            ),
            method: .get
        )
    }

    func getOrder(
        for customerID: UUID,
        with orderId: UUID
    ) async throws
        -> [OrderModel]
    {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                customerID.uuidString,
                Path.orders.rawValue,
                orderId.uuidString
            ),
            method: .get
        )
    }

    func getChat(
        for customerID: UUID,
        with orderId: UUID
    ) async throws
        -> [OrderModel]
    {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                customerID.uuidString,
                Path.orders.rawValue,
                orderId.uuidString,
                Path.chats.rawValue
            ),
            method: .get
        )
    }
}
