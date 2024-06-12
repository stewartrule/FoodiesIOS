import SwiftHttp
import SwiftUI

struct OrderApiClient: ApiClient {
    let httpClient: HttpClient
    let baseUrl: HttpUrl

    enum Path: String {
        case base = "orders"
        case chats = "chats"
    }

    func addChat(
        order: OrderModel,
        message: String,
        token: String
    ) async throws -> ChatModel {
        let body = try JSONEncoder()
            .encode([
                "orderID": order.id.uuidString,
                "message": message,
            ])

        return try await decodableRequest(
            executor: httpClient.dataTask,
            url: baseUrl.path(
                Path.base.rawValue,
                Path.chats.rawValue
            ),
            method: .post,
            body: body,
            headers: [
                .authorization: "Bearer \(token)",
                .contentType: "application/json",
            ]
        )
    }
}
