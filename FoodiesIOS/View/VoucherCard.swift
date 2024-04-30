import SwiftUI

struct VoucherCard: View {
    var url =
        "https://images.pexels.com/photos/941869/pexels-photo-941869.jpeg?auto=compress&cs=tinysrgb&w=640"

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("#NEWUSER").font(.brandSemiBold(size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("Discount").font(.brandLight(size: 10))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("50").font(.brandSemiBold(size: 48))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Text("Up to $200 on your first order")
                        .font(.brandLight(size: 12)).foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                } label: {
                    Text("Claim Now").font(.brandSemiBold(size: 12))
                        .foregroundColor(.brandPrimary)
                }
                .padding(
                    EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
                )
                .background(.white)
                .clipShape(CornerRadiusShape(radius: 16, corners: .allCorners))
            }
            .padding(.all, 16)
            .frame(width: 204, height: 180, alignment: .leading)
            .background(.brandPrimary)
            .clipShape(CornerRadiusShape(radius: 16, corners: .allCorners))
        }
        .padding(.all, 0).frame(maxWidth: .infinity, alignment: .trailing)
        .background {
            AsyncImage(url: URL(string: url)) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                }
                else {
                    Rectangle().fill(.brandGray)
                }
            }
        }
        .clipShape(CornerRadiusShape(radius: 16, corners: .allCorners))
    }
}
