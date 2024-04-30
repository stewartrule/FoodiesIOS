import Foundation

struct OpeningHoursModel: Hashable, Codable {
    let id: UUID
    let weekday: Int
    let startTime: Int
    let endTime: Int
    let isClosed: Bool
}
