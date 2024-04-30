import SwiftUI

struct DiscountBadge: View {
    let percentage: Int

    var body: some View {
        Text("\(percentage)% off")
            .font(.brandRegular())
            .foregroundColor(.white)
            .padding(.vertical, .s1)
            .padding(.horizontal, .s2)
            .background(.brandHighlight)
            .clipShape(
                CornerRadiusShape(
                    radius: .s1,
                    corners: [.bottomLeft, .topRight]
                )
            )
    }
}
