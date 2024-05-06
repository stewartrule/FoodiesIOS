import SwiftUI
import MapKit
import ComposableArchitecture

struct OrderScreen: View {
    let store: StoreOf<RootReducer>
    let order: OrderModel

    @Binding var path: [RootPath]
    @State private var routes: [MKRoute] = []

    var from: CLLocationCoordinate2D { order.business.address.coordinate }

    var to: CLLocationCoordinate2D? {
        if let address = store.profile?.addresses.first {
            return address.coordinate
        }

        return nil
    }

    var bestRoute: MKRoute? { routes.first }

    var estimatedDeliveryTime: Date? {
        if let sentAt = order.sentAt, let route = bestRoute {
            return sentAt.addingTimeInterval(route.expectedTravelTime)
        }

        return nil
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: .s1) {
                BackButton { path = path.dropLast() }
                TextRegular("Delivery")
            }
            .frame(maxWidth: .infinity).padding(.all, .s2).background(.white)
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2).zIndex(1)

            ScrollView(.vertical) {
                VStack(spacing: .s2) {
                    if let profile = store.profile, let to = to {
                        DeliveryMap(
                            routes: routes,
                            business: order.business,
                            profile: profile,
                            from: from,
                            to: to
                        )
                        .frame(maxWidth: .infinity, idealHeight: 340)
                    }

                    if let route = bestRoute {
                        VStack {
                            Text(
                                "Afstand \((route.distance / 1000).toFixed(1)) km"
                            )
                            .font(.brandRegular(size: 14))

                            if let sentAt = order.sentAt {
                                Text("Sent: \(sentAt.description)")
                                    .font(.brandRegular(size: 14))
                            }

                            if let time = estimatedDeliveryTime {
                                Text(
                                    "EST. \((route.expectedTravelTime / 60).toFixed(1)) min."
                                )
                                .font(.brandRegular(size: 14))

                                Text("Bezorgtijd \(time.description)")
                                    .font(.brandRegular(size: 14))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }

                    DeliveryStatus(order: order).padding(.horizontal, .s2)

                    if order.sentAt != nil, let courier = order.courier {
                        Divider()
                        CourierCtaAlt(courier: courier) {
                            path.append(.chat(order))
                        }
                        .padding(.horizontal, .s2)
                        Divider()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.getOrder(order)) }
        .task { getRoutes() }
    }

    func getRoutes() {
        guard let to = to else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile

        Task {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                routes = response.routes
            }
            catch { print(error) }
        }
    }
}
