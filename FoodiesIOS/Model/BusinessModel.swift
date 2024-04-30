import Foundation
import MapKit

struct BusinessModel: Hashable, Codable, Identifiable, Locatable {
    let id: UUID
    let name: String
    let deliveryCharge: Int
    let minimumOrderAmount: Int
    let image: ImageModel
    let address: AddressModel
    let businessType: BusinessTypeModel
    let cuisines: [CuisineModel]
    let openingHours: [OpeningHoursModel]
    let isOpen: Bool
    var distance: Double
    let reviewCount: Int
    let averageRating: Double
    let productTypes: [ProductTypeModel]
    var products: [ProductModel]

    var latitude: Double { address.latitude }
    var longitude: Double { address.longitude }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func withDistance(to location: Locatable) -> Self {
        var clone = self
        clone.distance = getDistanceTo(location)
        return clone
    }

    func isOpenAt(date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)

        return openingHours.contains { day in
            if day.weekday != weekday { return false }
            if day.isClosed { return false }

            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            let minutes = 60 * hour + minute
            return minutes >= day.startTime && minutes < day.endTime
        }
    }

    func matches(_ filters: BusinessFilters) -> Bool {
        if filters.hasFreeDelivery && deliveryCharge > 0 { return false }

        if filters.minimumOrderAmount == .lessThen10 && minimumOrderAmount >= 10
        {
            return false
        }

        if filters.minimumOrderAmount == .lessThen15 && minimumOrderAmount >= 15
        {
            return false
        }

        if getDistanceTo(filters.center) > filters.distance { return false }

        if filters.isOpenNow && !isOpenAt(date: Date()) { return false }

        return filters.cuisines.count > 0
            ? cuisines.contains(where: { filters.cuisines.contains($0) }) : true
    }
}

extension Array where Element == BusinessModel {
    func matching(_ filters: BusinessFilters, center: Locatable) -> Self {
        return filter({ $0.matches(filters) })
            .map({ $0.withDistance(to: center) })
            .sorted(by: { lhs, rhs in
                switch filters.sort {
                    case .deliveryCharge:
                        lhs.deliveryCharge < rhs.deliveryCharge
                    case .distance: lhs.distance < rhs.distance
                    case .minimumOrderAmount:
                        lhs.minimumOrderAmount < rhs.minimumOrderAmount
                    case .name:
                        lhs.name.localizedCompare(rhs.name) == .orderedAscending
                    case .rating: lhs.averageRating > rhs.averageRating
                }
            })
    }

    var cuisines: [CuisineModel] {
        flatMap({ $0.cuisines }).unique()
            .sorted { lhs, rhs in
                lhs.name.localizedCompare(rhs.name) == .orderedAscending
            }
    }
}

struct BusinessListingModel: Codable {
    let center: CoordinateModel
    let businesses: [BusinessModel]
}
