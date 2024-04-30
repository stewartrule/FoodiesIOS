import Foundation
import SwiftHttp

enum RootAction {
    case getBusinesses(Locatable, Double)
    case getBusinessesResponse(BusinessListingModel)
    case getBusiness(BusinessModel)
    case getBusinessResponse(BusinessModel)
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
    case addChat(ChatModel)
    case addProduct(ProductModel)
    case removeProduct(ProductModel)
    case getRecommendations(Locatable, Double)
    case getRecommendationsResponse(BusinessListingModel)
}
