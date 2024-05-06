import SwiftUI
import MapKit
import ComposableArchitecture

struct BusinessesScreen: View {
    let store: StoreOf<RootReducer>
    @Binding var path: [RootPath]

    var businesses: [BusinessModel] { store.filteredBusinesses }
    var filters: BusinessFilters { store.businessFilters }
    var cuisines: [CuisineModel] { store.businesses.map({ $1 }).cuisines }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .s1) {
                if filters.center.latitude != 0 {
                    BusinessMap(
                        initialPosition: .camera(
                            MapCamera(
                                centerCoordinate: CLLocationCoordinate2D(
                                    latitude: filters.center.latitude,
                                    longitude: filters.center.longitude
                                ),
                                distance: filters.distance * 1000 * 2
                            )
                        ),
                        businesses: businesses
                    ) { context in
                        store.send(
                            .getBusinesses(
                                context.camera.centerCoordinate,
                                filters.distance
                            )
                        )
                    }
                    .frame(maxWidth: .infinity, idealHeight: 340)
                    .onAppear {
                        store.send(
                            .getBusinesses(filters.center, filters.distance)
                        )
                    }
                }
                else {
                    Rectangle().fill(.brandGray)
                        .frame(maxWidth: .infinity, idealHeight: 340)
                }

                ToggleButtonBar(
                    options: BusinessSort.allCases,
                    selected: filters.sort,
                    label: { $0.label },
                    onSelect: { selected in store.send(.setSort(selected)) }
                )

                MultiToggleButtonBar(
                    options: cuisines,
                    selected: filters.cuisines,
                    label: { $0.name.capitalized },
                    onSelect: { cuisine in store.send(.toggleCuisine(cuisine)) }
                )

                ToggleButtonBar(
                    options: [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
                    selected: filters.distance,
                    label: { "\(Int($0)) km" },
                    onSelect: { distance in
                        store.send(.getBusinesses(filters.center, distance))
                    }
                )

                ForEach(businesses, id: \.id) { business in
                    VStack(spacing: .s2) {
                        BusinessListItem(business: business) { _ in
                            store.send(.getBusiness(business))
                            path.append(.business(business))
                        }
                        if business != businesses.last { Divider() }
                    }
                    .padding(
                        EdgeInsets(
                            top: .s1,
                            leading: .s2,
                            bottom: 0,
                            trailing: .s2
                        )
                    )
                }
            }
            .padding({ safeArea, orientation, screen in
                EdgeInsets(
                    top: .s8,
                    leading: 0,
                    bottom: safeArea.bottom,
                    trailing: 0
                )
            })
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading) {
            HStack(spacing: .s1) {
                BackButton { path = path.dropLast() }
                TextRegular("Recommendations")
            }
            .frame(maxWidth: .infinity).padding(.all, .s2).background(.white)
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}
