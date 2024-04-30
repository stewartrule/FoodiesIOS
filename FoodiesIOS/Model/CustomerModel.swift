import Foundation

struct CustomerModel: Equatable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let telephone: String
    let email: String
}

struct ProfileModel: Equatable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let telephone: String
    let email: String
    let addresses: [AddressModel]
    let image: ImageModel?
}

struct ProfileResponse: Equatable, Codable {
    let profile: ProfileModel
    let pendingOrders: [OrderModel]
}

struct ProfileOrdersModel: Equatable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let telephone: String
    let email: String
    let addresses: [AddressModel]
    let orders: [OrderModel]
}
