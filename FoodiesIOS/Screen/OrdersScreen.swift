import SwiftUI
import ComposableArchitecture

struct OrdersScreen: View {
    let store: StoreOf<RootReducer>

    @Binding var path: [RootPath]

    var orders: [OrderModel] {
        store.orders.map { $1 }
            .sorted(by: { lhs, rhs in lhs.createdAt > rhs.createdAt })
    }
    var ongoing: [OrderModel] { orders.filter({ $0.deliveredAt == nil }) }
    var history: [OrderModel] { orders.filter({ $0.deliveredAt != nil }) }

    var body: some View {
        VStack(spacing: .s2) {
            ScrollView(.vertical) {
                VStack(spacing: .s2) {
                    VStack(spacing: .s2) {
                        TextSemiBold("Ongoing").padding(.horizontal, .s2)
                        OrderList(orders: ongoing, path: $path)
                    }
                    .padding(.vertical, .s2)
                    .background(
                        RoundedRectangle(cornerRadius: .s2, style: .continuous)
                            .fill(.white)
                    )

                    VStack(spacing: .s2) {
                        TextSemiBold("History").padding(.horizontal, .s2)
                        OrderList(orders: history, path: $path)
                    }
                    .padding(.vertical, .s2)
                    .background(
                        RoundedRectangle(cornerRadius: .s2, style: .continuous)
                            .fill(.white)
                    )
                }
                .padding { safeArea, orientation, screen in
                    .init(
                        top: .s2,
                        leading: 0,
                        bottom: safeArea.bottom + .s2 + .s4 + .s2,
                        trailing: 0
                    )
                }
                .task { store.send(.getOrders) }
            }
        }
        .background(.brandGrayLight)
    }
}

struct OrderList: View {
    var orders: [OrderModel]
    @Binding var path: [RootPath]

    var body: some View {
        VStack(spacing: .s2) {
            ForEach(orders, id: \.id) { order in
                OrderSummary(order: order, onTrack: { path.append(.order($0)) })
                    .padding(.horizontal, .s2)

                if order.sentAt != nil, let courier = order.courier {
                    CourierCta(
                        courier: courier,
                        order: order,
                        onRequestChat: { path.append(.chat(order)) },
                        onRequestReview: { print("Add review") }
                    )
                    .padding(.horizontal, .s2)
                }

                if order != orders.last { Divider() }
            }
        }
    }
}
