import SwiftUI
import MapKit

struct HomeScreen: View {
    @Binding var store: RootStore
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

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .s2) {
                HStack(spacing: .s1) {
                    VStack(spacing: 0) {
                        TextSemiBold("Recommendations near you", size: 16)
                        TextRegular("We choose delicious and close to you")
                            .foregroundColor(.brandGray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    SecondaryButton(label: "See all") {
                        path.append(.businesses)
                    }
                }
                .padding(.vertical, 0).padding(.horizontal, .s2)

                ForEach(cuisines, id: \.id) { cuisine in
                    VStack(spacing: .s1) {
                        TextSemiBold(cuisine.name.capitalized)
                            .padding(.horizontal, .s2)

                        ScrollView(.horizontal) {
                            HStack(spacing: .s2) {
                                ForEach(
                                    businessesForCuisine(cuisine: cuisine),
                                    id: \.id
                                ) { business in
                                    ForEach(business.products.prefix(2).map { $0 }, id: \.id) {
                                        product in
                                        RecommendationCard(
                                            product: product,
                                            business: business,
                                            width: 160
                                        ) { path.append(.business(business)) }
                                    }
                                }
                            }
                            .padding(.vertical, 0).padding(.horizontal, .s2)
                            .fixedSize(horizontal: false, vertical: true)
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
