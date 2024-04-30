import Foundation

struct CourierModel: Hashable, Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let telephone: String
    let image: ImageModel?
}
