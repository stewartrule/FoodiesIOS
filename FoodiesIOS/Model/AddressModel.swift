import Foundation
import MapKit

struct AddressModel: Hashable, Codable, Locatable, Identifiable {
    let id: UUID
    let street: String
    let postalCodeSuffix: String
    let houseNumber: Int
    let latitude: Double
    let longitude: Double
    let postalArea: PostalAreaModel

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
