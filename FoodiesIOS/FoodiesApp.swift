import SwiftHttp
import SwiftUI
import ComposableArchitecture

func resetDefaultAppearance() {
    let appearance = UITabBar.appearance()
    appearance.unselectedItemTintColor = .white
    appearance.backgroundColor = .clear
    appearance.isHidden = true
}

@main
struct FoodiesApp: App {
    let businessApiClient: BusinessApiClient
    let profileApiClient: ProfileApiClient
    let orderApiClient: OrderApiClient

    init() {
        resetDefaultAppearance()

        let httpClient = UrlSessionHttpClient(logLevel: .info)
        let baseUrl = HttpUrl(scheme: "http", host: "127.0.0.1", port: 8080)

        businessApiClient = BusinessApiClient(
            httpClient: httpClient,
            baseUrl: baseUrl
        )
        profileApiClient = ProfileApiClient(
            httpClient: httpClient,
            baseUrl: baseUrl
        )
        orderApiClient = OrderApiClient(
            httpClient: httpClient,
            baseUrl: baseUrl
        )
    }

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: RootReducer.State()) {
                    RootReducer(
                        getBusinesses: { center, distance in
                            try await businessApiClient.getBusinesses(
                                center: center,
                                distance: distance
                            )
                        },
                        getRecommendations: { center, distance in
                            try await businessApiClient.getRecommendations(
                                center: center,
                                distance: distance
                            )
                        },
                        getBusiness: { business in
                            try await businessApiClient.getBusiness(
                                business: business
                            )
                        },
                        getBusinessReviews: { business in
                            try await businessApiClient.getBusinessReviews(
                                business: business
                            )
                        },
                        getOrders: { token in
                            try await profileApiClient.getOrders(
                                token: token
                            )
                        },
                        getOrder: { order, token in
                            try await profileApiClient.getOrder(
                                order,
                                token: token
                            )
                        },
                        getProfile: { token in
                            try await profileApiClient.getProfile(
                                token: token
                            )
                        },
                        login: { email, password in
                            try await profileApiClient.login(
                                email: email,
                                password: password
                            )
                        },
                        addChat: { order, message, token in
                            try await orderApiClient.addChat(
                                order: order,
                                message: message,
                                token: token
                            )
                        }
                    )
                }
            )
        }
    }
}
