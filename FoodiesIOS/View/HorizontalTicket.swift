import SwiftUI

struct HorizontalTicket: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: .s1) {
                Text("40% off Food Discount")
                    .font(.brandRegular(size: .s2))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Min. order $ 10.00")
                    .font(.brandSemiBold(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Valid until - \(Text("August"))")
                    .font(.brandSemiBold(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("See details")
                    .font(.brandSemiBold(size: 12))
                    .foregroundStyle(.brandPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.all, .s2)
            .background {
                TicketShape(radius: .s1 * 1.5, fill: .brandGray, flipped: true)
            }

            TicketShape(radius: .s1 * 1.5, fill: .brandPrimary)
                .frame(maxWidth: 80, maxHeight: .infinity)
                .overlay {
                    Rectangle()
                        .fill(.clear)
                        .overlay { ZigZagEdge() }
                        .clipped()
                        .padding(.vertical, .s1 * 1.5)

                    RoundedRectangle(cornerRadius: .s1 / 2)
                        .fill(.brandPrimaryLight)
                        .padding(.all, .s2)
                        .overlay {
                            Barcode()
                                .fill(.brandPrimary)
                                .padding(.all, .s3)
                        }
                }
        }
    }
}

private struct TicketShape: View {
    var radius: Double = .s1
    var fill: Color = .brandGray
    var flipped: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let height = size.height
            let width = size.width

            Path { path in
                path.move(to: CGPoint(x: radius, y: 0))
                path.addLine(to: CGPoint(x: width - radius, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: width, y: radius),
                    control: CGPoint(x: width, y: 0)
                )
                path.addLine(to: CGPoint(x: width, y: height - radius))
                path.addQuadCurve(
                    to: CGPoint(x: width - radius, y: height),
                    control: CGPoint(x: width, y: height)
                )
                path.addLine(to: CGPoint(x: radius, y: height))
                path.addQuadCurve(
                    to: CGPoint(x: 0, y: height - radius),
                    control: CGPoint(x: radius, y: height - radius)
                )
                path.addLine(to: CGPoint(x: 0, y: height - radius))
                path.addLine(to: CGPoint(x: 0, y: radius))
                path.addQuadCurve(
                    to: CGPoint(x: radius, y: 0),
                    control: CGPoint(x: radius, y: radius)
                )
            }
            .fill(fill)
            .rotationEffect(Angle(degrees: flipped ? 180 : 0), anchor: .center)
        }
    }
}

private struct ZigZagEdge: View {
    var fill: Color = .brandGray
    var flipped: Bool = false
    var spacing: Double = 2

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            for i in 0...64 {
                path.addLine(
                    to: CGPoint(
                        x: i % 2 == 0 ? 0 : spacing,
                        y: Double(i) * spacing
                    )
                )
            }
        }
        .fill(fill)
    }
}

private struct Barcode: Shape {
    let sizes = [
        2, 1, 1, 1, 3, 2, 2, 1, 1, 2, 3, 1, 1, 2, 1, 2, 3, 1, 2, 2, 1, 2, 3, 1,
        1, 2, 1, 2, 1, 1, 1, 3, 2, 2, 1, 1, 2, 3, 1, 1, 2, 1, 2, 3, 1, 2, 2, 1,
    ]

    func path(in rect: CGRect) -> Path {
        var y = 0
        let width = Int(rect.width)
        let height = Int(rect.height)
        var path = Path()
        for size in sizes {
            if y <= height {
                path.move(to: CGPoint(x: 0, y: y))
                path.addRect(CGRect(x: 0, y: y, width: width, height: size))
            }
            y += size + 2
        }
        return path
    }
}
