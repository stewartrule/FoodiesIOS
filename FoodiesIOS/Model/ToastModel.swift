import Foundation

struct ToastModel: Equatable {
    enum ToastType {
        case info
        case warning
        case error
    }

    let message: String
    let created: Date
    let type: ToastType
    let shown: Bool
}
