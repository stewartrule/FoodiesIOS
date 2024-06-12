import SwiftUI
import MapKit
import ComposableArchitecture

struct HomeScreen: View {
    let store: StoreOf<RootReducer>
    @Binding var path: [RootPath]

    var filters: BusinessFilters { store.businessFilters }
    var cuisines: [CuisineModel] { businesses.cuisines }
    var businesses: [BusinessModel] { store.filteredBusinesses }
    var discounts: [ProductModel] {
        businesses
            .filter({ $0.products.count > 0 })
            .flatMap { $0.products.filter({ $0.discounts.count > 0 }) }
    }

    func businessesForCuisine(cuisine: CuisineModel) -> [BusinessModel] {
        businesses
            .filter({ $0.products.count > 0 })
            .filter({ $0.cuisines.contains(cuisine) })
    }

    func recommendationsForCuisine(
        cuisine: CuisineModel
    ) -> [(BusinessModel, ProductModel)] {
        return businessesForCuisine(cuisine: cuisine)
            .flatMap { business in
                business.products.prefix(4).map { (business, $0) }
            }
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .s2) {
                HStack(spacing: .s1) {
                    VStack(spacing: 0) {
                        TextSemiBold("Restaurants near you", size: 16)
                        TextRegular("Find recommendations near you")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    SecondaryButton(label: "See all") {
                        path.append(.businesses)
                    }
                }
                .padding(.all, .s2)
                .background(.brandPrimary.opacity(0.1))
                .clipShape(CornerRadiusShape(radius: 8, corners: .allCorners))
                .padding(.horizontal, .s2)

                ForEach(cuisines, id: \.id) { cuisine in
                    let recommendations = recommendationsForCuisine(
                        cuisine: cuisine
                    )

                    if recommendations.count > 0 {
                        VStack(spacing: .s1) {
                            TextSemiBold(cuisine.name.capitalized)
                                .padding(.horizontal, .s2)

                            ScrollView(.horizontal) {
                                HStack(spacing: .s2) {
                                    ForEach(
                                        recommendations,
                                        id: \.1
                                    ) {
                                        (business, product) in
                                        RecommendationCard(
                                            product: product,
                                            business: business,
                                            width: 160
                                        ) { path.append(.business(business)) }
                                    }
                                }
                                .padding(.vertical, 0)
                                .padding(.horizontal, .s2)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding({ safeArea, orientation, screen in
                EdgeInsets(
                    top: .s2,
                    leading: 0,
                    bottom: safeArea.bottom + .s2 + .s4,
                    trailing: 0
                )
            })
        }
    }
}
