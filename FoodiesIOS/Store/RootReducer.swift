import Foundation

struct RootReducer: Reducer {
    func handle(_ oldState: RootState, _ action: RootAction) -> RootState {
        var state = oldState
        switch action {
            case .getBusinesses(let center, let distance):
                state.businessFilters.center = .init(
                    latitude: center.latitude,
                    longitude: center.longitude
                )
                state.businessFilters.distance = distance

            case .setSort(let sort):
                state.businessFilters.sort = sort

            case .getOrderResponse(let order):
                state.orders[order.id] = order
                for chat in order.chat {
                    state.chats[chat.id] = chat
                }

            case .getBusinessesResponse(let response):
                state.businessFilters.center = response.center
                for update in response.businesses {
                    if let existing = state.businesses[update.id] {
                        var updated = update
                        updated.products =
                            updated.products.count > 0
                            ? updated.products : existing.products
                        state.businesses[update.id] = updated
                    }
                    else {
                        state.businesses[update.id] = update
                    }
                }

            case .getBusinessResponse(let business):
                state.businesses[business.id] = business

            case .toggleCuisine(let cuisine):
                let cuisines = state.businessFilters.cuisines
                state.businessFilters.cuisines =
                    cuisines.contains(cuisine)
                    ? cuisines.filter({ $0 != cuisine }) : cuisines + [cuisine]

            case .getOrdersResponse(let orders):
                for order in orders { state.orders[order.id] = order }

            case .getProfileResponse(let res):
                state.profile = res.profile
                for order in res.pendingOrders {
                    state.orders[order.id] = order
                    for chat in order.chat {
                        state.chats[chat.id] = chat
                    }
                }

            case .addChat(let chat):
                state.chats[chat.id] = chat

            case .addProduct(let product):
                let quantity = state.selectedProducts[product.id] ?? 0
                state.selectedProducts[product.id] = quantity + 1

            case .removeProduct(let product):
                let quantity = state.selectedProducts[product.id] ?? 0
                state.selectedProducts[product.id] =
                    quantity > 0 ? quantity - 1 : 0

            default:
                return state
        }

        return state
    }
}
