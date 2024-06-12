import SwiftUI

struct OrderSummary: View {
    let order: OrderModel
    var address: AddressModel { order.address }
    var status: String {
        if order.deliveredAt != nil { return "Your order has been delivered" }
        if order.sentAt != nil { return "Your order has been picked up" }
        if order.preparedAt != nil {
            return "Your order is currently being made"
        }
        return "Your order is waiting to be prepared"
    }
    var products: [ProductModel] { order.items.map({ $0.product }) }
    var summary: String { products.map(\.name).joined(separator: ", ") }
    var total: Double { Double(products.map(\.price).reduce(0, +)) }
    var createdAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, y"
        return formatter.string(from: order.createdAt)
    }
    var image: ImageModel? { products.compactMap({ $0.image }).first }

    var onTrack: (OrderModel) -> Void

    var body: some View {
        VStack(spacing: .s2) {
            Text("\(order.business.name)").font(.brandBold(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: .s2) {
                if let image = image {
                    NetworkImage(image: image, width: 56, height: 56)
                        .clipShape(
                            CornerRadiusShape(radius: 8, corners: .allCorners)
                        )
                }

                VStack(spacing: 0) {
                    Text(summary).font(.brandRegular()).lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(createdAt).font(.brandRegular())
                        .foregroundStyle(.brandGray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\((total / 100.0).toFixed(2))").font(.brandBold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Divider()

            HStack {
                Text(status).font(.brandRegular())
                    .frame(maxWidth: .infinity, alignment: .leading)

                if order.deliveredAt != nil, order.reviews.first != nil {
                    SecondaryButton(label: "Change review", outline: true) {
                    }
                }
                else if order.deliveredAt == nil {
                    SecondaryButton(label: "Track order", outline: true) {
                        onTrack(order)
                    }
                }
            }
        }
    }
}

struct CourierAvatar: View {
    let courier: CourierModel

    var body: some View {
        if let image = courier.image {
            NetworkImage(image: image, width: .s4, height: .s4)
                .clipShape(CornerRadiusShape(radius: .s4, corners: .allCorners))
        }
        else {
            RoundedRectangle(cornerRadius: .s4).fill(.brandGrayLight)
                .frame(width: .s4, height: .s4)
        }
    }
}

struct CourierCta: View {
    let courier: CourierModel
    let order: OrderModel
    let onRequestChat: () -> Void
    let onRequestReview: () -> Void

    var body: some View {
        HStack(spacing: .s1) {
            CourierAvatar(courier: courier)

            Text("\(courier.firstName) \(courier.lastName)")
                .font(.brandRegular())
                .frame(maxWidth: .infinity, alignment: .leading)

            if order.deliveredAt != nil {
                SecondaryButton(
                    label: "Add review",
                    outline: true,
                    action: onRequestReview
                )
            }
            else {
                SecondaryButton(
                    label: "Chat",
                    outline: true,
                    action: onRequestChat
                )
            }
        }
        .padding(.all, .s1)
        .overlay(
            CornerRadiusShape(radius: .s1, corners: .allCorners)
                .stroke(Color.brandGray.opacity(0.3), lineWidth: 1.0)
        )
    }
}

struct CourierCtaAlt: View {
    let courier: CourierModel
    let onRequestChat: () -> Void

    var body: some View {
        HStack(spacing: .s1) {
            CourierAvatar(courier: courier)

            VStack(spacing: 0) {
                Text("Courier").font(.brandRegular())
                    .foregroundColor(.brandGray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(courier.firstName) \(courier.lastName)")
                    .font(.brandSemiBold())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            IconButton(
                icon: .phone,
                background: .brandPrimaryLight,
                foreground: .brandPrimary
            ) {}

            IconButton(icon: .bubble, action: onRequestChat)
        }
    }
}
