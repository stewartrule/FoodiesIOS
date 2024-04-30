import Foundation

struct ProductModel: Hashable, Codable {
    let id: UUID
    let name: String
    let description: String
    let products: [ProductModel]
    let productType: ProductTypeModel
    let price: Int
    let discounts: [DiscountModel]
    let image: ImageModel
}

extension ProductModel {
    static let sample: Self = .init(
        id: UUID(),
        name: "Crepe",
        description: "Plate of Waffles and Raspberries",
        products: [],
        productType: .init(id: UUID(), name: "Crepe"),
        price: 799,
        discounts: [],
        image: .init(
            id: UUID(),
            name: "Flat Lay of Indian Cuisine",
            src: "http://127.0.0.1:8080/images/9792458.webp",
            h: 19,
            s: 13,
            b: 36
        )
    )

    static let samples: [Self] = [
        .init(
            id: UUID(),
            name: "Tarte tatin",
            description: "Tarte Tatin Caramelized Fruits",
            products: [],
            productType: .init(id: UUID(), name: "Tarte tatin"),
            price: 1199,
            discounts: [],
            image: .init(
                id: UUID(),
                name: "Flat Lay of Indian Cuisine",
                src: "http://127.0.0.1:8080/images/1132047.webp",
                h: 19,
                s: 13,
                b: 36
            )
        ),
        .init(
            id: UUID(),
            name: "Croissant",
            description: "Croissant With Butter",
            products: [],
            productType: .init(id: UUID(), name: "Croissant"),
            price: 699,
            discounts: [],
            image: .init(
                id: UUID(),
                name: "Flat Lay of Indian Cuisine",
                src: "http://127.0.0.1:8080/images/256523.webp",
                h: 19,
                s: 13,
                b: 36
            )
        ),
        .init(
            id: UUID(),
            name: "Escargots",
            description: "a Snail Shell",
            products: [],
            productType: .init(id: UUID(), name: "Escargots"),
            price: 799,
            discounts: [],
            image: .init(
                id: UUID(),
                name: "Flat Lay of Indian Cuisine",
                src: "http://127.0.0.1:8080/images/9792458.webp",
                h: 19,
                s: 13,
                b: 36
            )
        ),
    ]
}
