import Foundation

struct Page<T: Equatable & Codable>: Equatable, Codable {
    struct Metadata: Equatable, Codable {
        let total: Int
        let page: Int
        let per: Int
    }

    let metadata: Metadata
    let items: [T]
}
