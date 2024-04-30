import SwiftUI

struct BrandTextFieldStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.brandRegular(size: .s2))
            .frame(maxWidth: .infinity, idealHeight: .s6)
            .padding(.horizontal, .s2)
            .background(
                RoundedRectangle(cornerRadius: .s1, style: .continuous)
                    .fill(.clear).strokeBorder(Color.brandGray, lineWidth: 1)
            )
    }
}
