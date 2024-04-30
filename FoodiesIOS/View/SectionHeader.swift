import SwiftUI

struct SectionHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 0) {
                Text("Recommendations near you")
                    .font(.brandBold(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("We choose delicious and close to you")
                    .font(.brandRegular())
                    .foregroundColor(.brandGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            SecondaryButton(label: "See all") { print("see all") }
        }
    }
}
