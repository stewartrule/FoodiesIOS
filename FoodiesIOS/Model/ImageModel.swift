import SwiftUI

struct ImageModel: Hashable, Codable, Identifiable {
    let id: UUID
    let name: String
    let src: String
    let h: Int
    let s: Int
    let b: Int

    var color: Color {
        .init(
            hue: Double(h) / 360,
            saturation: Double(s) / 100,
            brightness: Double(b) / 100
        )
    }
}
