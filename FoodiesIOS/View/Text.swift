import SwiftUI

struct TextRegular: View {
    var text: String
    var size: CGFloat = 14
    var alignment: Alignment = .leading

    public init(
        _ text: String,
        size: CGFloat = 14,
        alignment: Alignment = .leading
    ) {
        self.text = text
        self.size = size
        self.alignment = alignment
    }

    var body: some View {
        Text(text).font(.brandRegular(size: size))
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct TextSemiBold: View {
    var text: String
    var size: CGFloat = 14
    var alignment: Alignment = .leading

    public init(
        _ text: String,
        size: CGFloat = 14,
        alignment: Alignment = .leading
    ) {
        self.text = text
        self.size = size
        self.alignment = alignment
    }

    var body: some View {
        Text(text).font(.brandSemiBold(size: size))
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}
