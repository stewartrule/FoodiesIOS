import SwiftUI

struct ToggleButton: View {
    var selected: Bool = false
    var label: String
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(label).font(.brandSemiBold(size: 12))
        }
        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
        .foregroundColor(selected ? .white : .gray)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(selected ? .brandPrimary : .clear)
                .strokeBorder(
                    selected ? .brandPrimary : Color.brandGray,
                    lineWidth: 1
                )
        )
    }
}
