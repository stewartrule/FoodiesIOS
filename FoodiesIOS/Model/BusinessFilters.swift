import Foundation

enum BusinessSort: String, Codable, CaseIterable {
    case rating
    case distance
    case name
    case minimumOrderAmount
    case deliveryCharge

    var label: String {
        switch self {
            case .rating: "Beoordeling"
            case .distance: "Afstand"
            case .name: "Naam"
            case .minimumOrderAmount: "Min. bestelbedrag"
            case .deliveryCharge: "Bezorgkosten"
        }
    }
}

enum MinimumOrderAmount: String, Codable {
    case ignore
    case lessThen10
    case lessThen15
}

struct BusinessFilters: Equatable {
    var sort: BusinessSort = .distance
    var rating: Int?
    var center: CoordinateModel = .init(latitude: 0, longitude: 0)
    var distance: Double = 4
    var minimumOrderAmount: MinimumOrderAmount = .ignore
    var isOpenNow: Bool = false
    var hasFreeDelivery: Bool = false
    var hasDiscounts: Bool = false
    var cuisines: [CuisineModel] = []
}
