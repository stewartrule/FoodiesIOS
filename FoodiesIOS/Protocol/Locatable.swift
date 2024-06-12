import Foundation

protocol Locatable {
    var latitude: Double { get }
    var longitude: Double { get }
}

extension Double {
    var radians: Double {
        self * Double.pi / 180
    }
}

extension Locatable {
    func getDistance(to locatable: Locatable) -> Double {
        let EARTH_RADIUS_KM: Double = 6371.0

        let dLat = (locatable.latitude - latitude).radians
        let dLon = (locatable.longitude - longitude).radians

        let rLat1 = (latitude).radians
        let rLat2 = (locatable.latitude).radians

        let a =
            sin(dLat / 2) * sin(dLat / 2) + sin(dLon / 2) * sin(dLon / 2)
            * cos(rLat1) * cos(rLat2)

        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return EARTH_RADIUS_KM * c
    }
}
