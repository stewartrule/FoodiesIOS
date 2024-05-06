import SwiftUI
import ComposableArchitecture

struct BusinessDetailScreen: View {
    let store: StoreOf<RootReducer>
    let business: BusinessModel
    @Binding var path: [RootPath]

    func quantityFor(_ product: ProductModel) -> Int {
        return store.selectedProducts[product.id] ?? 0
    }

    var products: [ProductModel] {
        return store.businesses[business.id]?.products ?? []
    }

    var selectedProducts: [ProductModel] {
        let productIds = store.selectedProducts.keys
        return products.filter { product in productIds.contains(product.id) }
    }

    var total: Int {
        selectedProducts.reduce(0) { sum, product in
            let quantity = store.selectedProducts[product.id] ?? 0
            return sum + (quantity * product.price)
        }
    }

    var productTypes: [ProductTypeModel] {
        products.map({ $0.productType }).unique()
            .sorted { lhs, rhs in
                lhs.name.localizedCompare(rhs.name) == .orderedAscending
            }
    }

    var visibleProductTypes: [ProductTypeModel] {
        if let productType = selectedProductType { return [productType] }
        return productTypes
    }

    var address: AddressModel { business.address }

    @State var selectedProductType: ProductTypeModel?

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: .s1) {
                    BackButton { path = path.dropLast() }

                    TextRegular(business.businessType.name)
                }
                .padding(.horizontal, .s2).padding(.vertical, .s2)

                HStack(spacing: .s2) {
                    NetworkImage(image: business.image, width: .s7, height: .s7)
                        .clipShape(
                            CornerRadiusShape(radius: .s1, corners: .allCorners)
                        )

                    VStack(spacing: 0) {
                        TextSemiBold(business.name, size: 16)
                        TextRegular(
                            "\(address.street) \(address.houseNumber), \(address.postalArea.city.name)",
                            size: 12
                        )
                    }
                }
                .padding(.horizontal, .s2)
                .padding(.bottom, .s2)

                Divider()
                    .padding(.horizontal, .s2)

                HStack(spacing: .s2) {
                    VStack(spacing: 0) {
                        TextSemiBold(
                            "\(business.averageRating.toFixed(1))",
                            size: 12
                        )
                        TextRegular("Check reviews", size: 12)
                    }
                    VStack(spacing: 0) {
                        TextSemiBold(
                            "\(business.distance.toFixed(1)) km",
                            size: 12
                        )
                        TextRegular("Distance", size: 12)
                    }
                    VStack(spacing: 0) {
                        TextSemiBold(
                            "\(business.reviewCount) ratings",
                            size: 12
                        )
                        TextRegular("Good taste", size: 12)
                    }
                }
                .padding(.all, .s2)

                Divider().padding(.horizontal, .s2)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ToggleButton(
                            selected: selectedProductType == nil,
                            label: "All"
                        ) { selectedProductType = nil }

                        ForEach(productTypes, id: \.self) { option in
                            ToggleButton(
                                selected: selectedProductType == option,
                                label: option.name
                            ) { selectedProductType = option }
                        }
                    }
                    .padding(.vertical, .s2).padding(.horizontal, .s2)
                }
            }
            .background(.white)
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .zIndex(1)

            ScrollView(.vertical) {
                VStack(spacing: .s2) {
                    ForEach(visibleProductTypes, id: \.id) { productType in
                        VStack(spacing: .s2) {
                            TextSemiBold(productType.name)

                            VStack(spacing: .s2) {
                                ForEach(
                                    products.filter({ product in
                                        product.productType == productType
                                    }),
                                    id: \.id
                                ) { product in
                                    OrderListItem(
                                        product: product,
                                        onAdd: {
                                            store.send(.addProduct(product))
                                        },
                                        onRemove: {
                                            store.send(
                                                .removeProduct(product)
                                            )
                                        },
                                        count: quantityFor(product)
                                    )
                                }
                            }
                        }
                        .padding(.all, .s2)
                        .background(
                            RoundedRectangle(
                                cornerRadius: .s2,
                                style: .continuous
                            )
                            .fill(.white)
                        )
                    }
                }
                .padding(.vertical, .s2)
            }
        }
        .background(.brandGrayLight)
        .overlay(alignment: .bottom) {
            if total > 0 {
                TextSemiBold("$ \((Double(total) / 100.0).toFixed(2))")
                    .foregroundColor(.white).padding(.all, .s2)
                    .background(.brandPrimary)
                    .clipShape(
                        CornerRadiusShape(radius: .s1, corners: .allCorners)
                    )
                    .padding(.all, .s2)
                    .transition(
                        .asymmetric(
                            insertion: .push(from: .bottom),
                            removal: .push(from: .top)
                        )
                    )
                    .animation(.default, value: total > 0)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.getBusiness(business)) }
    }
}
