import SwiftUI

struct Toast: View {
    let toast: ToastModel

    var color: Color {
        switch toast.type {
            case .error: .red
            case .warning: .orange
            case .info: .blue
        }
    }

    var body: some View {
        TextRegular(
            toast.message,
            size: 14,
            alignment: .center
        )
        .padding(.all, .s1)
        .background(
            color
        )
        .foregroundStyle(.white)
    }
}
