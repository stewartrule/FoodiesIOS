import Foundation

struct DiscountModel: Hashable, Codable {
    let id: UUID
    let name: String
    let percentage: Int
}
