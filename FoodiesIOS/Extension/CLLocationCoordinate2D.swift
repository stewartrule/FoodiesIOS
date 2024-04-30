import MapKit

extension Array where Element == CLLocationCoordinate2D {
    var centroid: CLLocationCoordinate2D? {
        let count = Double(self.count)
        if count == 0 { return nil }
        if count == 1 { return self.first }

        let latitude = map(\.latitude).reduce(0, +) / count
        let longitude = map(\.longitude).reduce(0, +) / count

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Locatable {}
