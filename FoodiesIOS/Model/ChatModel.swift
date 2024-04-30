import Foundation

struct ChatModel: Hashable, Codable {
    enum Sender: String, Codable { case customer, courier }

    struct ParentRef: Hashable, Codable { let id: UUID }

    let id: UUID
    let message: String
    let sender: Sender
    let createdAt: Date
    let seenAt: Date?
    let customer: ParentRef
    let courier: ParentRef
    let order: ParentRef

    static var samples: [Self] {
        var result: [Self] = []
        for i in 0...5 {
            result.append(
                .init(
                    id: UUID(),
                    message: "Hallo",
                    sender: i % 2 == 0 ? .courier : .customer,
                    createdAt: Date()
                        .addingTimeInterval(TimeInterval(i * 60 * -1)),
                    seenAt: Date(),
                    customer: .init(id: UUID()),
                    courier: .init(id: UUID()),
                    order: .init(id: UUID())
                )
            )
        }
        return result
    }
}
