import SwiftUI

struct VerticalTicket: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .s2) {
                HStack(spacing: .s2) {
                    RoundedRectangle(cornerRadius: .s5).fill(.brandPrimary)
                        .frame(width: .s5, height: .s5)

                    VStack(spacing: 0) {
                        Text("Es Teh Indonesia").font(.brandSemiBold(size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Specialty tea shop").font(.brandRegular(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text("See details").font(.brandSemiBold(size: 12))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                VStack(spacing: 0) {
                    Text("40% off drinks discount")
                        .font(.brandSemiBold(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(
                        "Buy any tea for the first time and receive a 40% discount. Minimum purchase 30,-"
                    )
                    .font(.brandRegular(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(.all, .s3)
            .background {
                TicketShape(radius: .s1 * 1.5, fill: .brandGray, flipped: false)
            }

            HStack(spacing: .s1) {
                VStack(spacing: 0) {
                    Text("Expired").font(.brandSemiBold(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 28)
                        .overlay(alignment: .bottomLeading) {
                            Image(systemName: "calendar").imageScale(.medium)
                        }

                    TextRegular("Jan 30, 2022", size: 12).padding(.leading, 28)
                }
                .frame(maxWidth: 128, alignment: .leading)

                VStack(spacing: 0) {
                    Text("Used").font(.brandSemiBold(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 28)
                        .overlay(alignment: .bottomLeading) {
                            Image(systemName: "list.bullet.rectangle")
                                .imageScale(.medium)
                        }

                    TextRegular("40 times (60 remaining)", size: 12)
                        .padding(.leading, 28)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading).padding(.all, .s3)
            .background {
                TicketShape(radius: .s1 * 1.5, fill: .brandGray, flipped: true)
            }
            .overlay {
                LineShape()
                    .stroke(
                        .brandBackground,
                        style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                    )
                    .padding(.horizontal, .s1 * 1.5)
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
                    control: CGPoint(x: width - radius, y: height - radius)
                )
                path.addLine(to: CGPoint(x: radius, y: height))
                path.addQuadCurve(
                    to: CGPoint(x: 0, y: height - radius),
                    control: CGPoint(x: radius, y: height - radius)
                )
                path.addLine(to: CGPoint(x: 0, y: radius))
                path.addQuadCurve(
                    to: CGPoint(x: radius, y: 0),
                    control: CGPoint(x: 0, y: 0)
                )
            }
            .fill(fill)
            .rotationEffect(Angle(degrees: flipped ? 180 : 0), anchor: .center)
        }
    }
}

private struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
