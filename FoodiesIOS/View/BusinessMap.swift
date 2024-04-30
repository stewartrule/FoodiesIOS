import SwiftUI
import MapKit

struct BusinessMap: View {
    var initialPosition: MapCameraPosition
    var businesses: [BusinessModel]
    var onMapCameraChange: (MapCameraUpdateContext) -> Void

    var body: some View {
        Map(initialPosition: initialPosition) {
            ForEach(businesses, id: \.id) { business in
                Annotation(business.name, coordinate: business.coordinate) {
                    Icon(icon: .cutlery).onTapGesture { print(business.id) }
                }
                .annotationTitles(.hidden)
            }
        }
        .onMapCameraChange(frequency: .onEnd, { ctx in onMapCameraChange(ctx) })
    }
}
