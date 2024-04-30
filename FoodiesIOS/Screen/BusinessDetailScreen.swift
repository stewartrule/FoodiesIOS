import SwiftUI

struct BusinessDetailScreen: View {
    @Binding var store: RootStore
    let business: BusinessModel
    @Binding var path: [RootPath]

    func quantityFor(_ product: ProductModel) -> Int {
        if let quantity = store.selectedProducts[product.id] { return quantity }
        return 0
    }

    var products: [ProductModel] {
        if let business = store.businesses[business.id] {
            return business.products
        }

        return []
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

    @State var scrollPosition: UUID?

    var body: some View {
        VStack(spacing: .s2) {
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
            .clipShape(
                CornerRadiusShape(
                    radius: .s2,
                    corners: [.bottomLeft, .bottomRight]
                )
            )
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

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
                                            withAnimation {
                                                store.send(.addProduct(product))
                                            }
                                        },
                                        onRemove: {
                                            withAnimation {
                                                store.send(
                                                    .removeProduct(product)
                                                )
                                            }
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
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.getBusiness(business)) }
    }
}
