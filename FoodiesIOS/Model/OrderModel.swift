import Foundation

struct BusinessAdressModel: Hashable, Codable {
    let id: UUID
    let name: String
    let address: AddressModel
}

struct OrderModel: Hashable, Codable, Identifiable {
    let id: UUID
    let courier: CourierModel?
    let createdAt: Date
    let preparedAt: Date?
    let sentAt: Date?
    let deliveredAt: Date?
    let address: AddressModel
    let business: BusinessAdressModel
    let items: [OrderItemModel]
    let chat: [ChatModel]
    let reviews: [ReviewModel]

    static let samples: [Self] = []
}
