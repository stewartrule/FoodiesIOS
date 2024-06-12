import SwiftUI

struct EmailTextField: View {
    var label: String
    var placeholder: String
    var onChange: (String) -> Void
    var onSubmit: () -> Void

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
        self.onChange = onChange
        self.onSubmit = onSubmit
        self._value = State(initialValue: initialValue)
    }

    var body: some View {
        VStack(spacing: 4) {
            TextFieldLabel(label: label)

            TextField(placeholder, text: $value)
                .modifier(BrandTextFieldStyleViewModifier())
                .focused($isFocused)
                .keyboardType(.emailAddress)
                .onChange(of: value, initial: true, { onChange(value) })
                .onSubmit(onSubmit)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
    }
}
