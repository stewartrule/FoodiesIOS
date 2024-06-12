import SwiftUI

struct BusinessListItem: View {
    let business: BusinessModel

    var productTypes: [String] {
        business.productTypes.map({ $0.name }).sorted()
    }

    var initialProductTypes: [String] { productTypes.prefix(3).map({ $0 }) }

    var onSelect: (BusinessModel) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            NetworkImage(image: business.image, width: .s6, height: .s6)
                .clipShape(CornerRadiusShape(radius: .s1, corners: .allCorners))

            VStack {
                HStack {
                    Text(business.name).font(.brandSemiBold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Text("\(business.averageRating.toFixed(1))")
                            .font(.brandSemiBold(size: 12))
                        Text("\(business.distance.toFixed(1)) km")
                            .font(.brandSemiBold(size: 12))
                    }
                    .frame(alignment: .trailing)
                }

                HStack {
                    Text(initialProductTypes.joined(separator: ", "))
                        .font(.brandRegular(size: 12)).foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("1 min").font(.brandRegular(size: 12))
                        .foregroundColor(.gray).frame(alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).background(.white)
        .onTapGesture { onSelect(business) }
    }
}
