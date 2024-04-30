import Foundation

struct PostalAreaModel: Hashable, Codable, Locatable {
    let id: UUID
    let postalCode: Int
    let latitude: Double
    let longitude: Double
    let city: CityModel
}

struct CityModel: Hashable, Codable {
    let id: UUID
    let name: String
}

struct ProvinceModel: Hashable, Codable { let id: UUID }
