import Foundation

struct RootState {
    var token: String = ""
    var profile: ProfileModel? = nil
    var orders: [UUID: OrderModel] = [:]
    var businesses: [UUID: BusinessModel] = [:]
    var businessFilters: BusinessFilters = .init()
    var toasts: [ToastModel] = []
    var chats: [UUID: ChatModel] = [:]
    var selectedProducts: [UUID: Int] = [:]

    var filteredBusinesses: [BusinessModel] {
        businesses.map({ $1 })
            .matching(
                businessFilters,
                center: profile?.addresses.first?.coordinate
                    ?? businessFilters.center
            )
    }
}
