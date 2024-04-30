import SwiftUI

struct ChatMessage: View {
    var chat: ChatModel
    var inset: CGFloat = 72

    var body: some View {
        VStack(spacing: 4) {
            Text(chat.message)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.vertical, .s1)
                .padding(.horizontal, .s2)
                .foregroundStyle(.white)
                .background(
                    CornerRadiusShape(
                        radius: .s1,
                        corners: chat.sender == .customer
                            ? [.bottomLeft, .topRight, .topLeft]
                            : [.bottomRight, .topRight, .topLeft]
                    )
                    .fill(chat.sender == .customer ? .brandPrimary : .brandGray)
                )
                .font(.brandRegular())
                .frame(
                    maxWidth: .infinity,
                    alignment: chat.sender == .customer ? .trailing : .leading
                )

            Text(chat.createdAt.formatted())
                .font(.brandRegular(size: 12))
                .frame(
                    maxWidth: .infinity,
                    alignment: chat.sender == .customer ? .trailing : .leading
                )
        }
        .padding(
            EdgeInsets(
                top: 0,
                leading: chat.sender == .customer ? inset : 0,
                bottom: 0,
                trailing: chat.sender == .customer ? 0 : inset
            )
        )
    }
}
