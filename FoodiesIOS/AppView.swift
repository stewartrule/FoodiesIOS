import SwiftUI

struct TabData: Hashable {
    let name: String
    let icon: String
}

enum RootPath: Hashable {
    case businesses
    case business(BusinessModel)
    case chat(OrderModel)
    case order(OrderModel)
}

struct AppView: View {
    @Binding var store: RootStore

    let tabs: [TabData] = [
        .init(name: "Home", icon: "house"),
        .init(name: "Orders", icon: "pencil.and.list.clipboard.rtl"),
        .init(name: "Promo", icon: "gift"),
        .init(name: "Profile", icon: "person.fill"),
    ]

    @State var path: [RootPath] = []
    @State var selectedIndex = 0

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedIndex) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) {
                        index,
                        tab in
                        switch index {
                            case 0: HomeScreen(store: $store, path: $path)
                            case 1: OrdersScreen(store: $store, path: $path)
                            case 2: PromosScreen(store: $store, path: $path)
                            case 3: ProfileScreen(store: $store, path: $path)
                            default: Text(tab.name)
                        }
                    }
                }
                .padding({ safeArea, orientation, screen in
                    EdgeInsets(
                        top: .s2 + .s4 + .s2 + .s4 + .s2,
                        leading: 0,
                        bottom: 0,
                        trailing: 0
                    )
                })

                TabBar(tabs: tabs, selectedIndex: $selectedIndex)
                    .padding(.horizontal, .s2)
            }
            .navigationDestination(for: RootPath.self) { path in
                switch path {
                    case .business(let business):
                        BusinessDetailScreen(
                            store: $store,
                            business: business,
                            path: $path
                        )
                    case .chat(let order):
                        ChatScreen(store: $store, order: order, path: $path)
                    case .order(let order):
                        OrderScreen(store: $store, order: order, path: $path)
                    case .businesses:
                        BusinessesScreen(store: $store, path: $path)
                }
            }
            .background(.brandBackground).task { store.send(.getProfile) }
            .overlay(alignment: .topLeading) {
                SearchBar(store: $store, path: $path) {
                    selectedIndex = 3
                }
            }
            .toolbar(.hidden, for: .navigationBar).ignoresSafeArea(.keyboard)
        }
    }
}

struct SearchBar: View {
    @Binding var store: RootStore
    @Binding var path: [RootPath]
    var onTapProfile: () -> Void
    @State private var search: String = ""

    var body: some View {
        VStack(spacing: .s2) {
            HStack {
                VStack(spacing: 0) {
                    if let profile = store.profile {
                        TextRegular("Your location", size: 12)
                        if let address = profile.addresses.first {
                            TextSemiBold(
                                "\(address.street) \(address.houseNumber), \(address.postalArea.city.name)",
                                size: 12
                            )
                        }
                    }
                    else {
                        TextRegular("Your location", size: 12)
                        TextRegular("...", size: 12)
                    }
                }

                IconButton(
                    icon: .notification,
                    background: .brandGrayLight.opacity(0.5),
                    foreground: .brandSecondary
                ) { print("view notifications") }

                if let profile = store.profile, let image = profile.image {
                    NetworkImage(image: image, width: .s4, height: .s4)
                        .clipShape(
                            CornerRadiusShape(radius: .s4, corners: .allCorners)
                        )
                        .onTapGesture {
                            onTapProfile()
                        }
                }
                else {
                    RoundedRectangle(cornerRadius: .s4).fill(.brandGrayLight)
                        .frame(width: .s4, height: .s4)
                }
            }
            SearchTextField(search: $search)
        }
        .padding(.horizontal, .s2)
        .frame(maxWidth: .infinity, maxHeight: .s2 + .s4 + .s2 + .s4 + .s2)
        .background(.white).compositingGroup()
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct TabBar: View {
    var tabs: [TabData]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: .s1) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    selectedIndex = index
                } label: {
                    Tab(selected: selectedIndex == index, tab: tab)
                }
                .padding(.vertical, .s2).background(.clear)
                .foregroundColor(.brandGray).frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity).padding(.horizontal, .s2)
        .background(
            RoundedRectangle(cornerRadius: .s6, style: .continuous).fill(.white)
                .shadow(color: .black.opacity(0.2), radius: .s1, x: 0, y: 4)
        )
    }
}

struct Tab: View {
    var selected: Bool
    var tab: TabData

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: tab.icon).imageScale(.medium)
                .foregroundColor(selected ? .brandPrimary : .brandGray)
                .frame(width: .s3, height: .s3, alignment: .center)
            TextSemiBold(tab.name, size: 12, alignment: .center)
                .foregroundColor(selected ? .brandPrimary : .brandGray)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SearchTextField: View {
    @Binding var search: String
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("What would you like to eat?", text: $search)
            .font(.brandRegular(size: 14))
            .frame(maxWidth: .infinity, maxHeight: .s4)
            .padding(.horizontal, .s2)
            .background(
                RoundedRectangle(cornerRadius: .s1, style: .continuous)
                    .fill(.brandGrayLight)
            )
            .focused($isFocused).keyboardType(.default)
            .onChange(of: search, initial: true, { print(search) })
            .textInputAutocapitalization(.never).disableAutocorrection(false)
    }
}

#Preview {
    return AppView(
        store: .constant(
            RootStore(
                state: RootState(),
                reducer: RootReducer(),
                effects: RootEffects(
                    getBusinesses: { postalCode, distance in
                        return .init(
                            center: .init(latitude: 52.352, longitude: 5.18),
                            businesses: []
                        )
                    },
                    getRecommendations: { postalCode, distance in
                        return .init(
                            center: .init(latitude: 52.352, longitude: 5.18),
                            businesses: []
                        )
                    },
                    getBusiness: { business in return nil },
                    getOrders: {
                        .init(
                            metadata: .init(total: 1, page: 1, per: 1),
                            items: []
                        )
                    },
                    getOrder: { order in order },
                    getProfile: { nil }
                )
            )
        )
    )
}
