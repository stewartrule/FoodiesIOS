import SwiftHttp
import SwiftUI

struct ProfileToken: Codable {
    struct Ref: Codable {
        var id: UUID?
    }

    var id: UUID?
    var value: String
    var customer: Ref
}

struct ProfileApiClient: ApiClient {
    let httpClient: HttpClient
    let baseUrl: HttpUrl

    enum Path: String {
        case base = "profile"
        case orders = "orders"
        case login = "login"
    }

    func login(email: String, password: String) async throws -> ProfileToken? {
        let auth =
            "\(email):\(password)".data(using: .utf8)?.base64EncodedString()
            ?? ""

        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.login.rawValue),
            method: .post,
            headers: [
                .authorization: "Basic \(auth)"
            ]
        )
    }

    func getProfile(token: String) async throws -> ProfileResponse? {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.base.rawValue),
            method: .get,
            headers: [
                .authorization: "Bearer \(token)"
            ]
        )
    }

    func getOrders(token: String) async throws -> Page<OrderModel> {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(Path.base.rawValue, Path.orders.rawValue),
            method: .get,
            headers: [
                .authorization: "Bearer \(token)"
            ]
        )
    }

    func getOrder(_ order: OrderModel, token: String) async throws -> OrderModel
    {
        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                Path.orders.rawValue,
                order.id.uuidString
            ),
            method: .get,
            headers: [
                .authorization: "Bearer \(token)"
            ]
        )
    }
}
