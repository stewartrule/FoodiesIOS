import SwiftUI

struct SignInForm: View {
    var onSubmit: (_ email: String, _ password: String) -> Void

    @State private var remember = false
    @State private var email = "shaun.krajcik.1621@lynch.name"
    @State private var password = "foodies"

    var body: some View {
        VStack(spacing: .s2) {
            EmailTextField(
                label: "Email",
                placeholder: "Enter your email",
                initialValue: email,
                onChange: { value in
                    email = value
                },
                onSubmit: {
                    onSubmit(email, password)
                }
            )
            .padding(.horizontal, .s2)

            PasswordTextField(
                label: "Password",
                placeholder: "Enter your password",
                initialValue: password,
                onChange: { value in
                    password = value
                },
                onSubmit: {
                    onSubmit(email, password)
                }
            )
            .padding(.horizontal, .s2)

            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brandGrayLight)
                    .frame(width: 24, height: 24)

                TextRegular("Remember me")
            }
            .padding(.horizontal, .s2)

            PrimaryButton(label: "Sign in") {
                onSubmit(email, password)
            }
            .padding(.horizontal, .s2)

            HStack(spacing: 8) {
                Divider()
                Text("or").font(.brandRegular(size: 12))
                Divider()
            }
            .padding(.all, .s2)

            VStack(spacing: .s1) {
                PrimaryButton(label: "Continue with Face Id", theme: .secondary)
                {
                    print("n/a")
                }
                .padding(.horizontal, .s2)

                PrimaryButton(label: "Continue with Google", theme: .secondary)
                {
                    print("n/a")
                }
                .padding(.horizontal, .s2)

                PrimaryButton(
                    label: "Continue with Facebook",
                    theme: .secondary
                ) {
                    print("n/a")
                }
                .padding(.horizontal, .s2)
            }
        }
    }
}
