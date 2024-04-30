import SwiftUI

struct TextFieldLabel: View {
    var label: String

    var body: some View {
        Text(label)
            .font(.brandSemiBold(size: 14))
            .foregroundStyle(.brandGray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
