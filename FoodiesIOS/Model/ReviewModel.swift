import Foundation

struct ReviewModel: Hashable, Codable, Identifiable {
    struct Customer: Hashable, Codable {
        let firstName: String
        let lastName: String
    }

    let id: UUID
    let review: String
    let isAnonymous: Bool
    let rating: Int
    let createdAt: Date
    let customer: Customer
}
