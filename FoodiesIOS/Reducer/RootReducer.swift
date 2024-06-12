import ComposableArchitecture
import Foundation
import SwiftHttp

@Reducer
struct RootReducer {
    let getBusinesses:
        (_ center: Locatable, _ distance: Double) async throws ->
            BusinessListingModel
    let getRecommendations:
        (_ center: Locatable, _ distance: Double) async throws ->
            BusinessListingModel
    let getBusiness: (BusinessModel) async throws -> BusinessModel?
    let getBusinessReviews: (BusinessModel) async throws -> Page<ReviewModel>
    let getOrders: (_ token: String) async throws -> Page<OrderModel>
    let getOrder:
        (_ order: OrderModel, _ token: String) async throws -> OrderModel?
    let getProfile: (_ token: String) async throws -> ProfileResponse?
    let login:
        (_ email: String, _ password: String) async throws -> ProfileToken?
    let addChat:
        (_ order: OrderModel, _ message: String, _ token: String) async throws
            -> ChatModel?

    @ObservableState
    struct State: Equatable {
        var token: String = ""
        var profile: ProfileModel? = nil
        var orders: [UUID: OrderModel] = [:]
        var businesses: [UUID: BusinessModel] = [:]
        var businessFilters: BusinessFilters = .init()
        var toasts: [ToastModel] = []
        var chats: [UUID: ChatModel] = [:]
        var selectedProducts: [UUID: Int] = [:]
        var reviews: [UUID: ReviewModel] = [:]

        var filteredBusinesses: [BusinessModel] {
            businesses.map({ $1 })
                .matching(
                    businessFilters,
                    center: profile?.addresses.first?.coordinate
                        ?? businessFilters.center
                )
        }
    }

    enum Action {
        case getBusinesses(Locatable, Double)
        case getBusinessesResponse(BusinessListingModel)
        case getBusiness(BusinessModel)
        case getBusinessResponse(BusinessModel)
        case getBusinessReviews(BusinessModel)
        case getBusinessReviewsResponse([ReviewModel])
        case getOrders
        case getOrdersResponse([OrderModel])
        case getOrder(OrderModel)
        case getOrderResponse(OrderModel)
        case toggleCuisine(CuisineModel)
        case setSort(BusinessSort)
        case addToast(ToastModel)
        case addError(HttpError)
        case getProfile
        case getProfileResponse(ProfileResponse)
        case addProduct(ProductModel)
        case removeProduct(ProductModel)
        case getRecommendations(Locatable, Double)
        case getRecommendationsResponse(BusinessListingModel)
        case login(email: String, password: String)
        case loginResponse(ProfileToken)
        case addChat(order: OrderModel, message: String)
        case addedChat(ChatModel)
        case logout
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case let .addChat(order, message):
                    return .run { [token = state.token] send in
                        do {
                            if let chat = try await addChat(
                                order,
                                message,
                                token
                            ) {
                                await send(.addedChat(chat))
                            }
                        }
                        catch let error as HttpError {
                            return await send(.addError(error))
                        }
                        catch { print(error) }
                    }

                case let .getBusinessReviews(business):
                    return .run { send in
                        do {
                            let result = try await getBusinessReviews(business)
                            await send(
                                .getBusinessReviewsResponse(result.items)
                            )
                        }
                        catch let error as HttpError {
                            return await send(.addError(error))
                        }
                        catch { print(error) }
                    }

                case let .getBusinessReviewsResponse(reviews):
                    for review in reviews {
                        state.reviews[review.id] = review
                    }
                    return .none

                case let .login(email, password):
                    return .run { send in
                        do {
                            if let result = try await login(email, password) {
                                await send(.loginResponse(result))
                            }
                        }
                        catch let error as HttpError {
                            return await send(.addError(error))
                        }
                        catch { print(error) }
                    }

                case .loginResponse(let token):
                    state.token = token.value
                    return .run { send in
                        do {
                            if let response = try await getProfile(token.value)
                            {
                                await send(.getProfileResponse(response))
                            }
                        }
                        catch let error as HttpError {
                            return await send(.addError(error))
                        }
                        catch { print(error) }
                    }

                case .logout:
                    state.token = ""
                    state.profile = nil
                    return .none

                case let .addError(error):
                    print(error)
                    let created = Date()
                    return .run { send in
                        await send(
                            .addToast(
                                .init(
                                    message: error.friendlyErrorDescription,
                                    created: created,
                                    type: .error,
                                    shown: false
                                )
                            )
                        )
                    }

                case let .addToast(toast):
                    state.toasts.append(toast)
                    return .none

                case let .getBusinesses(center, distance):
                    state.businessFilters.center = .init(
                        latitude: center.latitude,
                        longitude: center.longitude
                    )
                    state.businessFilters.distance = distance
                    return .run { send in
                        do {
                            let result = try await getBusinesses(
                                center,
                                distance
                            )
                            await send(.getBusinessesResponse(result))
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case let .getRecommendations(center, distance):
                    return .run { send in
                        do {
                            let result = try await getRecommendations(
                                center,
                                distance
                            )
                            await send(.getBusinessesResponse(result))
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case .getOrders:
                    return .run { [token = state.token] send in
                        do {
                            let page = try await getOrders(token)
                            return await send(.getOrdersResponse(page.items))
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case let .getOrder(order):
                    return .run { [token = state.token] send in
                        do {
                            if let response = try await self.getOrder(
                                order,
                                token
                            ) {
                                await send(.getOrderResponse(response))
                            }
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case let .getBusiness(business):
                    return .run { send in
                        do {
                            if let response = try await self.getBusiness(
                                business
                            ) {
                                await send(.getBusinessResponse(response))
                            }
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case .getProfile:
                    return .run { [token = state.token] send in
                        do {
                            if let response = try await self.getProfile(token) {
                                await send(.getProfileResponse(response))
                            }
                        }
                        catch let error as HttpError {
                            await (send(.addError(error)))
                        }
                        catch { print(error) }
                    }

                case let .getProfileResponse(res):
                    state.profile = res.profile
                    for order in res.pendingOrders {
                        state.orders[order.id] = order
                        for chat in order.chat {
                            state.chats[chat.id] = chat
                        }
                    }
                    let filters = state.businessFilters
                    return .run {
                        [
                            latitude = filters.center.latitude,
                            distance = filters.distance
                        ] send in
                        if let address = res.profile.addresses.first,
                            latitude == 0
                        {
                            await send(
                                .getRecommendations(
                                    address.postalArea,
                                    distance
                                )
                            )
                        }
                    }

                case .setSort(let sort):
                    state.businessFilters.sort = sort
                    return .none

                case .getOrderResponse(let order):
                    state.orders[order.id] = order
                    for chat in order.chat {
                        state.chats[chat.id] = chat

                        for review in order.reviews {
                            state.reviews[review.id] = review
                        }
                    }
                    return .none

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
                    return .none

                case .getBusinessResponse(let business):
                    state.businesses[business.id] = business
                    return .none

                case .toggleCuisine(let cuisine):
                    let cuisines = state.businessFilters.cuisines
                    state.businessFilters.cuisines =
                        cuisines.contains(cuisine)
                        ? cuisines.filter({ $0 != cuisine })
                        : cuisines + [cuisine]
                    return .none

                case .getOrdersResponse(let orders):
                    for order in orders {
                        state.orders[order.id] = order
                        for review in order.reviews {
                            state.reviews[review.id] = review
                        }
                    }
                    return .none

                case let .addedChat(chat):
                    state.chats[chat.id] = chat
                    return .none

                case .addProduct(let product):
                    let quantity = state.selectedProducts[product.id] ?? 0
                    state.selectedProducts[product.id] = quantity + 1
                    return .none

                case .removeProduct(let product):
                    let quantity = state.selectedProducts[product.id] ?? 0
                    state.selectedProducts[product.id] =
                        quantity > 0 ? quantity - 1 : 0
                    return .none

                default:
                    return .none
            }
        }
    }
}
