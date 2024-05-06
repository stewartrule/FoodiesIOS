import SwiftUI

struct PrimaryButton: View {
    enum Theme {
        case primary
        case secondary
    }

    var label: String
    var theme: Theme = .primary
    var action: () -> Void

    var body: some View {
        Text(label)
            .font(.brandRegular(size: 14))
            .padding(
                EdgeInsets(top: .s1, leading: .s2, bottom: .s1, trailing: .s2)
            )
            .frame(maxWidth: .infinity, idealHeight: .s6, alignment: .center)
            .foregroundColor(theme == .primary ? .white : .black)
            .background(
                RoundedRectangle(cornerRadius: .s1, style: .continuous)
                    .fill(
                        theme == .primary
                            ? .brandPrimary : .brandGray.opacity(0.2)
                    )
            )
            .onTapGesture(perform: action)
    }
}
