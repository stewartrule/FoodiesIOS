import SwiftUI

struct EmailTextField: View {
    var label: String
    var placeholder: String
    var onChange: (String) -> Void

    @State private var value: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 4) {
            TextFieldLabel(label: label)

            TextField(placeholder, text: $value)
                .modifier(BrandTextFieldStyleViewModifier())
                .focused($isFocused)
                .keyboardType(.emailAddress)
                .onChange(of: value, initial: true, { onChange(value) })
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }
}
