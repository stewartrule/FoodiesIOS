import SwiftUI

struct OpeningHours: View {
    let openingHours: [OpeningHoursModel]

    func toHHmm(_ total: Int) -> String {
        let minutes = Double(total % 60)
        let rest = Double(total) - minutes
        let hours = floor(rest / 60)
        return String(format: "%02d:%02d", Int(hours), Int(minutes))
    }

    var currentWeekday: Int {
        return Calendar.current.component(.weekday, from: Date())
    }

    var body: some View {
        VStack {
            ForEach(openingHours, id: \.id) { hours in
                let isCurrent = currentWeekday == hours.weekday.rawValue
                HStack {
                    Text(isCurrent ? "Today" : hours.weekday.day)
                        .font(
                            isCurrent
                                ? .brandBold(size: 12) : .brandRegular(size: 12)
                        )
                        .frame(width: 80, alignment: .leading)

                    if hours.isClosed {
                        Text("Closed")
                            .font(.brandRegular(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    else {
                        Text(
                            "\(toHHmm(hours.startTime)) - \(toHHmm(hours.endTime))"
                        )
                        .font(.brandRegular(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(alignment: .trailing) {
                            if isCurrent && hours.isOpenAt(date: Date()) {
                                Text("Now open")
                                    .padding(.all, 1)
                                    .font(.brandRegular(size: 11))
                                    .frame(width: 68, alignment: .center)
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 6,
                                            style: .continuous
                                        )
                                        .fill(.green)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .frame(maxWidth: 240, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    OpeningHours(
        openingHours: [
            .init(
                id: UUID(),
                weekday: .monday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: false
            ),
            .init(
                id: UUID(),
                weekday: .tuesday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: false
            ),
            .init(
                id: UUID(),
                weekday: .wednesday,
                startTime: 14 * 60,
                endTime: 24 * 60,
                isClosed: false
            ),
            .init(
                id: UUID(),
                weekday: .thursday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: true
            ),
            .init(
                id: UUID(),
                weekday: .friday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: false
            ),
            .init(
                id: UUID(),
                weekday: .saturday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: false
            ),
            .init(
                id: UUID(),
                weekday: .sunday,
                startTime: 60,
                endTime: 24 * 60,
                isClosed: false
            ),
        ]
    )
}
