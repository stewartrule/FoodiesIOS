import SwiftUI

struct PasswordTextField: View {
    var label: String
    var placeholder: String
    var onChange: (String) -> Void
    var onSubmit: () -> Void

    @State private var revealed: Bool = false
    @State private var value: String = ""
    @FocusState private var isFocused: Bool

    init(
        label: String,
        placeholder: String,
        initialValue: String,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        self.label = label
        self.placeholder = placeholder
        self._value = State(initialValue: initialValue)
        self.onChange = onChange
        self.onSubmit = onSubmit
    }

    var body: some View {
        VStack(spacing: 4) {
            TextFieldLabel(label: label)

            if revealed {
                TextField(placeholder, text: $value)
                    .modifier(BrandTextFieldStyleViewModifier())
                    .focused($isFocused)
                    .onChange(of: value, initial: true, { onChange(value) })
                    .onSubmit(onSubmit)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .overlay(
                        alignment: .trailing,
                        content: {
                            IconButton(
                                icon: .eyeSlash,
                                background: .clear,
                                foreground: .brandGray
                            ) { revealed = false }
                            .padding(.trailing, .s1)
                        }
                    )
            }
            else {
                SecureField(placeholder, text: $value)
                    .modifier(BrandTextFieldStyleViewModifier())
                    .focused($isFocused)
                    .onChange(of: value, initial: true, { onChange(value) })
                    .onSubmit(onSubmit)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .overlay(
                        alignment: .trailing,
                        content: {
                            IconButton(
                                icon: .eye,
                                background: .clear,
                                foreground: .brandGray
                            ) { revealed = true }
                            .padding(.trailing, .s1)
                        }
                    )
            }
        }
    }
}
