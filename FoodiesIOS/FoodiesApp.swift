import SwiftHttp
import SwiftUI

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
    }

    var body: some Scene {
        WindowGroup {
            AppView(
                store: .constant(
                    RootStore(
                        state: RootState(),
                        reducer: RootReducer(),
                        effects: RootEffects(
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
                            getOrders: { token in
                                try await profileApiClient.getOrders(token: token)
                            },
                            getOrder: { order, token in
                                try await profileApiClient.getOrder(order, token: token)
                            },
                            getProfile: { token in
                                try await profileApiClient.getProfile(token: token)
                            },
                            login: { email, password in
                                try await profileApiClient.login(email: email, password: password)
                            }
                        )
                    )
                )
            )
        }
    }
}
