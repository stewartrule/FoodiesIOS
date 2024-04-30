import SwiftUI

private struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

private struct DashedLine: View {
    let done: Bool
    let pending: Bool

    private func gradientOf(colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        LineShape().stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 2]))
            .frame(height: 2)
            .foregroundStyle(
                done
                    ? gradientOf(colors: [.brandPrimary])
                    : pending
                        ? gradientOf(colors: [
                            .brandPrimary, .brandGray, .brandGray,
                        ]) : gradientOf(colors: [.brandGray])
            )
            .padding(.top, 1)  // optically centered slightly better
    }
}

private struct DeliveryIcon: View {
    let icon: String
    let done: Bool
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(done ? .brandPrimary : .brandGray)
            .frame(width: .s3, height: .s3)
    }
}

struct DeliveryStatus: View {
    let order: OrderModel
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            DeliveryIcon(icon: "faxmachine", done: true)
            DashedLine(done: order.preparedAt != nil, pending: true)
            DeliveryIcon(icon: "frying.pan", done: order.preparedAt != nil)
            DashedLine(
                done: order.sentAt != nil,
                pending: order.preparedAt != nil
            )
            DeliveryIcon(icon: "car.fill", done: order.sentAt != nil)
            DashedLine(
                done: order.deliveredAt != nil,
                pending: order.sentAt != nil
            )
            DeliveryIcon(icon: "checkmark", done: order.deliveredAt != nil)
        }
    }
}
