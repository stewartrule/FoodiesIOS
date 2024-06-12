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
        products
            .map({ $0.productType })
            .unique()
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
    @State var showReviews = false
    @State var showOpeningHours = false

    var reviews: [ReviewModel] {
        store.reviews
            .map({ $1 })
            .filter({ $0.businessId == business.id })
            .sorted { lhs, rhs in
                lhs.createdAt > rhs.createdAt
            }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: .s1) {
                    BackButton(color: .white) { path = path.dropLast() }
                    TextRegular(business.businessType.name)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, .s2).padding(.vertical, .s2)

                HStack(spacing: .s2) {
                    NetworkImage(image: business.image, width: .s9, height: .s9)
                        .clipShape(
                            CornerRadiusShape(radius: .s1, corners: .allCorners)
                        )

                    VStack(spacing: 0) {
                        TextSemiBold(business.name, size: 16)
                            .foregroundColor(.white)
                        TextRegular(
                            "\(address.street) \(address.houseNumber), \(address.postalArea.city.name)",
                            size: 12
                        )
                        .foregroundColor(.white)
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
                        .foregroundColor(.white)
                        Text("^[\(business.reviewCount) rating](inflect: true)")
                            .font(.brandRegular(size: 12))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onTapGesture(perform: {
                        showReviews = true
                    })
                    VStack(spacing: 0) {
                        TextSemiBold(
                            "\(business.distance.toFixed(1)) km",
                            size: 12
                        )
                        .foregroundColor(.white)
                        TextRegular("Distance", size: 12)
                            .foregroundColor(.white)
                    }
                    VStack(spacing: 0) {
                        TextSemiBold(
                            business.isOpenAt(date: Date())
                                ? "Open now" : "Closed",
                            size: 12
                        )
                        .foregroundColor(.white)
                        TextRegular("Opening hours", size: 12)
                            .foregroundColor(.white)
                    }
                    .onTapGesture(perform: {
                        showOpeningHours = true
                    })
                }
                .padding(.all, .s2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(content: {
                GeometryReader { proxy in
                    AsyncImage(url: URL(string: business.image.src)) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height
                                )
                                .clipped()
                        }
                        else {
                            Rectangle().fill(Color.gray)
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height
                                )
                        }
                    }
                }
                .overlay(.black.opacity(0.5).blendMode(.multiply))
                .clipShape(
                    CornerRadiusShape(
                        radius: .s2,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
                .ignoresSafeArea()

            })
            .compositingGroup()
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .zIndex(1)

            ScrollView(.vertical) {
                VStack(spacing: .s2) {

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
                        .padding(.vertical, 0)
                        .padding(.horizontal, .s2)
                    }

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
                                            store.send(
                                                .addProduct(product),
                                                animation: .easeInOut
                                            )
                                        },
                                        onRemove: {
                                            store.send(
                                                .removeProduct(product),
                                                animation: .easeInOut
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
            }
        }
        .sheet(
            isPresented: $showOpeningHours,
            content: {
                OpeningHours(openingHours: business.openingHours)
                    .padding(.all, .s2)
            }
        )
        .sheet(
            isPresented: $showReviews,
            content: {
                ScrollView(.vertical) {
                    VStack(spacing: .s1) {
                        ForEach(reviews, id: \.id) { review in
                            VStack(spacing: .s1) {
                                TextRegular(review.review)
                                HStack {
                                    TextSemiBold(
                                        review.isAnonymous
                                            ? "Anonymous"
                                            : "\(review.customer.firstName) \(review.customer.lastName)",
                                        size: 10
                                    )

                                    Text("\(review.createdAt.formatted())")
                                        .font(.brandRegular(size: 10))
                                }
                            }
                            .padding(.all, .s1)
                            .background(
                                CornerRadiusShape(
                                    radius: .s1,
                                    corners: [
                                        .bottomLeft, .bottomRight, .topRight,
                                    ]
                                )
                                .fill(.brandGrayLight)
                            )
                        }
                    }
                    .padding(.all, .s2)
                }
                .task { store.send(.getBusinessReviews(business)) }
            }
        )
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.getBusiness(business)) }
    }
}
