import Foundation

struct OpeningHoursModel: Hashable, Codable {
    enum Day: Int, Codable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7

        var day: String {
            switch self {
                case .monday: "Monday"
                case .tuesday: "Tuesday"
                case .wednesday: "Wednesday"
                case .thursday: "Thursday"
                case .friday: "Friday"
                case .saturday: "Saturday"
                case .sunday: "Sunday"
            }
        }
    }

    let id: UUID
    let weekday: Day
    let startTime: Int
    let endTime: Int
    let isClosed: Bool
}

extension Array where Element == OpeningHoursModel {
    func isOpenAt(date: Date) -> Bool {
        return contains { hours in
            hours.isOpenAt(date: date)
        }
    }
}

extension OpeningHoursModel {
    func isOpenAt(date: Date) -> Bool {
        if isClosed { return false }

        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        if weekday.rawValue != day { return false }

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let minutes = 60 * hour + minute
        return minutes >= startTime && minutes < endTime
    }
}
