import SwiftUI
import MapKit
import ComposableArchitecture

struct BusinessesScreen: View {
    let store: StoreOf<RootReducer>
    @Binding var path: [RootPath]

    var businesses: [BusinessModel] { store.filteredBusinesses }
    var filters: BusinessFilters { store.businessFilters }

    @State private var isPresented: Bool = false

    var body: some View {
        ZStack {
            Group {
                if filters.center.latitude != 0 {
                    BusinessMap(
                        initialPosition: .camera(
                            MapCamera(
                                centerCoordinate: CLLocationCoordinate2D(
                                    latitude: filters.center.latitude,
                                    longitude: filters.center.longitude
                                ),
                                distance: filters.distance * 1000 * 4
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        store.send(
                            .getBusinesses(filters.center, filters.distance)
                        )
                    }
                }
                else {
                    Rectangle().fill(.brandGray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .sheet(
            isPresented: $isPresented,
            content: {
                BusinessListing(
                    store: store,
                    businesses: businesses,
                    onSelect: { business in
                        store.send(.getBusiness(business))
                        path.append(.business(business))

                        Task {
                            try await Task.sleep(seconds: 0.2)
                            await MainActor.run {
                                isPresented = false
                            }
                        }
                    }
                )
                .interactiveDismissDisabled()
                .presentationDetents([
                    .height(UIScreen.main.bounds.height * 0.1),
                    .height(UIScreen.main.bounds.height * 0.5),
                    .large,
                ])
                .presentationBackgroundInteraction(
                    .enabled(upThrough: .large)
                )
                .ignoresSafeArea()
            }
        )
        .onAppear {
            Task {
                try await Task.sleep(seconds: 0.2)
                await MainActor.run {
                    isPresented = true
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading) {
            HStack(spacing: .s1) {
                BackButton { path = path.dropLast() }
                TextRegular("Recommendations near you")
            }
            .frame(maxWidth: .infinity).padding(.all, .s2).background(.white)
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct BusinessListing: View {
    let store: StoreOf<RootReducer>

    let businesses: [BusinessModel]
    var onSelect: (BusinessModel) -> Void

    var cuisines: [CuisineModel] { store.businesses.map({ $1 }).cuisines }
    var filters: BusinessFilters { store.businessFilters }

    var body: some View {
        VStack(spacing: .s1) {
            ScrollView(.vertical) {
                VStack(spacing: .s1) {
                    ForEach(businesses, id: \.id) { business in
                        VStack(spacing: .s2) {
                            BusinessListItem(business: business) { _ in
                                onSelect(business)

                            }
                            if business != businesses.last { Divider() }
                        }
                        .padding(
                            EdgeInsets(
                                top: business != businesses.first ? .s1 : 0,
                                leading: .s2,
                                bottom: 0,
                                trailing: .s2
                            )
                        )
                    }
                }
                .padding({ safeArea, orientation, screen in
                    EdgeInsets(
                        top: .s1,
                        leading: 0,
                        bottom: safeArea.bottom + .s2,
                        trailing: 0
                    )
                })
            }
            .ignoresSafeArea()

        }
        .padding(.top, .s2)
        .background(.white)
        .clipShape(
            CornerRadiusShape(
                radius: .s2,
                corners: [.topLeft, .topRight]
            )
        )
        .compositingGroup()
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: -2)
    }
}
