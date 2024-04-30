import Foundation

struct OrderItemModel: Hashable, Codable {
    let id: UUID
    let quantity: Int
    let price: Int
    let product: ProductModel
}
