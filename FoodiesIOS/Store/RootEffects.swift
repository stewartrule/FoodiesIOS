import Foundation
import SwiftHttp

struct RootEffects: Effects {
    let getBusinesses:
        (_ center: Locatable, _ distance: Double) async throws ->
            BusinessListingModel
    let getRecommendations:
        (_ center: Locatable, _ distance: Double) async throws ->
            BusinessListingModel
    let getBusiness: (BusinessModel) async throws -> BusinessModel?
    let getOrders: () async throws -> Page<OrderModel>
    let getOrder: (OrderModel) async throws -> OrderModel?
    let getProfile: () async throws -> ProfileResponse?

    func handle(_ state: RootState, _ action: RootAction) async -> RootAction? {
        switch action {
            case .getBusinesses(let center, let distance):
                do {
                    let result = try await getBusinesses(center, distance)
                    return .getBusinessesResponse(result)
                }
                catch let error as HttpError { return .addError(error) }
                catch { print(error) }
                return nil

            case .getRecommendations(let center, let distance):
                do {
                    let result = try await getRecommendations(center, distance)
                    return .getBusinessesResponse(result)
                }
                catch let error as HttpError { return .addError(error) }
                catch { print(error) }
                return nil

            case .getOrders:
                do {
                    let page = try await getOrders()
                    return .getOrdersResponse(page.items)
                }
                catch let error as HttpError { return .addError(error) }
                catch { print(error) }
                return nil

            case .getOrder(let order):
                do {
                    if let response = try await self.getOrder(order) {
                        return .getOrderResponse(response)
                    }
                }
                catch let error as HttpError { return .addError(error) }
                catch { print(error) }
                return nil

            case .getBusiness(let business):
                do {
                    if let response = try await self.getBusiness(business) {
                        return .getBusinessResponse(response)
                    }
                }
                catch let error as HttpError { return (.addError(error)) }
                catch { print(error) }
                return nil

            case .getProfile:
                do {
                    if let response = try await self.getProfile() {
                        return .getProfileResponse(response)
                    }
                }
                catch let error as HttpError { return (.addError(error)) }
                catch { print(error) }
                return nil

            case .getProfileResponse(let res):
                if let address = res.profile.addresses.first,
                    state.businessFilters.center.latitude == 0
                {
                    return .getRecommendations(
                        address.postalArea,
                        state.businessFilters.distance
                    )
                }
                return nil

            default: return nil
        }
    }
}
