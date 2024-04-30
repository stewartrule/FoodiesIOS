import SwiftUI

struct NetworkImage: View {
    var image: ImageModel
    var width: Double
    var height: Double

    var body: some View {
        AsyncImage(url: URL(string: image.src)) { phase in
            if let image = phase.image {
                image.resizable().aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height).clipped()
            }
            else {
                Rectangle().fill(image.color)
                    .frame(width: width, height: height)
            }
        }
    }
}
