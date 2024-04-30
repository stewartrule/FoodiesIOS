import SwiftUI

struct ProfileScreen: View {
    @Binding var store: RootStore
    @Binding var path: [RootPath]

    var body: some View {
        ScrollView(.vertical) {
            if let profile = store.profile {
                VStack(spacing: .s1) {
                    if let image = profile.image {
                        NetworkImage(image: image, width: .s7, height: .s7)
                            .clipShape(
                                CornerRadiusShape(
                                    radius: .s7,
                                    corners: .allCorners
                                )
                            )
                    }
                    else {
                        RoundedRectangle(cornerRadius: .s7).fill(.brandPrimary)
                            .frame(width: .s7, height: .s7)
                    }

                    VStack(spacing: 0) {
                        TextSemiBold(
                            "\(profile.firstName) \(profile.lastName)",
                            alignment: .center
                        )
                        TextRegular("Consumer", alignment: .center)
                    }

                    SecondaryButton(label: "Edit profile") {
                        print("Edit profile")
                    }

                    VStack(spacing: 0) {
                        MenuItem(
                            title: "Review Courier",
                            description: "Review last courier"
                        )
                        Divider()
                        MenuItem(
                            title: "Review Courier",
                            description: "Review last courier"
                        )
                        Divider()
                        MenuItem(
                            title: "Review Courier",
                            description: "Review last courier"
                        )
                        Divider()
                        MenuItem(
                            title: "Review Courier",
                            description: "Review last courier"
                        )
                    }
                }
                .padding(.vertical, .s2)
            }
            else {
                Text("Login..")
            }
        }
    }
}

struct MenuItem: View {
    var title: String
    var description: String

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                TextSemiBold(title)
                TextRegular(description)
            }

            IconButton(
                icon: .chevronRight,
                background: .clear,
                foreground: .brandGray
            ) {}
        }
        .padding(.all, .s2).onTapGesture {}
    }
}
