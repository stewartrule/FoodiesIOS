import SwiftUI

struct RegistrationForm: View {
    @State private var remember = false

    var body: some View {
        VStack(spacing: .s2) {
            EmailTextField(
                label: "Email",
                placeholder: "Enter your email",
                onChange: { value in print(value) }
            )
            .padding(.horizontal, .s2)

            PasswordTextField(
                label: "Password",
                placeholder: "Enter your password"
            ) { value in print(value) }
            .padding(.horizontal, .s2)

            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brandGrayLight)
                    .frame(width: 24, height: 24)

                TextRegular("Remember me")
            }
            .padding(.horizontal, .s2)

            PrimaryButton(label: "Sign in")
                .padding(.horizontal, .s2)

            HStack(spacing: 8) {
                Divider()
                Text("or").font(.brandRegular(size: 12))
                Divider()
            }
            .padding(.all, .s2)

            VStack(spacing: .s1) {
                PrimaryButton(label: "Continue with Face Id", theme: .secondary)
                    .padding(.horizontal, .s2)
                PrimaryButton(label: "Continue with Google", theme: .secondary)
                    .padding(.horizontal, .s2)
                PrimaryButton(
                    label: "Continue with Facebook",
                    theme: .secondary
                )
                .padding(.horizontal, .s2)
            }
        }
    }
}
