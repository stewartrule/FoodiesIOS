import SwiftUI

struct RecommendationCard: View {
    var product: ProductModel
    var business: BusinessModel
    var width: Double = 168
    var onSelect: () -> Void

    var percentage: Int { product.discounts.first?.percentage ?? 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NetworkImage(
                image: product.image,
                width: width,
                height: width / (16 / 9)
            )
            .overlay(alignment: .topTrailing) {
                if percentage > 0 {
                    DiscountBadge(percentage: percentage)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(business.distance.toFixed(1)) km")
                        .font(.brandRegular(size: 12))

                    Text("8 min").font(.brandRegular(size: 12))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 2) {
                    Text(product.description)
                        .font(
                            .brandSemiBold(size: 14)
                                .leading(.tight)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Text(business.name).font(.brandRegular(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(business.address.postalArea.city.name)
                    .font(.brandRegular(size: 12))
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.all, 12)
            .background(
                ZStack {
                    CornerRadiusShape(
                        radius: 8,
                        corners: [.bottomLeft, .bottomRight]
                    )
                    .fill(.gray.opacity(0.2))
                }
            )
        }
        .frame(width: width, alignment: .leading)
        .clipShape(CornerRadiusShape(radius: 8, corners: .allCorners))
        .onTapGesture { onSelect() }
    }
}
