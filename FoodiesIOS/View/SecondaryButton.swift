import SwiftUI

struct SecondaryButton: View {
    var label: String
    var outline: Bool = false
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(label).font(.brandRegular(size: 12))
        }
        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
        .foregroundColor(.brandPrimary)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(outline ? .clear : .brandPrimary.opacity(0.2))
                .strokeBorder(.brandPrimary, lineWidth: outline ? 1 : 0)
        )
    }
}
