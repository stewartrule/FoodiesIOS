import SwiftUI

struct OrderListItem: View {
    let product: ProductModel
    let onAdd: () -> Void
    let onRemove: () -> Void
    var count = 0

    var description: String {
        if product.products.count == 0 { return product.description }

        return product.products.map(\.name).prefix(3).joined(separator: ", ")
    }

    var body: some View {
        HStack(alignment: .center, spacing: .s2) {
            NetworkImage(image: product.image, width: .s7, height: .s7)
                .clipShape(CornerRadiusShape(radius: .s1, corners: .allCorners))

            VStack(spacing: 0) {
                Text(description).font(.brandSemiBold())
                    .foregroundColor(.primary).lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\((Double(product.price) / 100.0).toFixed(2))")
                    .font(.brandSemiBold()).foregroundColor(.brandSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 0) {
                IconButton(
                    icon: .minus,
                    background: count == 0 ? .brandGray : .brandPrimary,
                    size: .s2,
                    disabled: count == 0
                ) { onRemove() }

                Text("\(count)").font(.brandRegular(size: 14))
                    .frame(width: .s4, height: .s2)

                IconButton(icon: .plus, size: .s2) { onAdd() }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
