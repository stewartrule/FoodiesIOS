import SwiftUI
import MapKit

struct DeliveryMap: View {
    @State private var camera = MapCameraPosition.automatic

    let routes: [MKRoute]
    let business: BusinessAdressModel
    let profile: ProfileModel
    let from: CLLocationCoordinate2D
    let to: CLLocationCoordinate2D

    var body: some View {
        Map(position: $camera) {
            Annotation(business.name, coordinate: from) {
                Icon(icon: .cutlery).onTapGesture { print(business.id) }
            }
            .annotationTitles(.hidden)

            Annotation(profile.firstName, coordinate: to) {
                Icon(
                    icon: .profile,
                    background: .white,
                    foreground: .brandPrimary,
                    size: .s3,
                    iconSize: .small
                )
                .onTapGesture { print(business.id) }
            }
            .annotationTitles(.hidden)

            if let route = routes.first {
                MapPolyline(route).stroke(.brandPrimary, lineWidth: 4)
                    .strokeStyle(style: .init(lineWidth: 4, lineJoin: .round))
            }
        }
    }
}
