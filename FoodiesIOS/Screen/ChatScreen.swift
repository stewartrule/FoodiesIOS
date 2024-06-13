import SwiftUI
import ComposableArchitecture

struct ChatScreen: View {
    let store: StoreOf<RootReducer>
    let order: OrderModel

    @Binding var path: [RootPath]
    @State private var message: String = ""
    @FocusState private var isFocused: Bool

    var chats: [ChatModel] {
        return store.chats
            .compactMap({ $1 })
            .filter({ $0.order.id == order.id })
            .sorted { lhs, rhs in lhs.createdAt < rhs.createdAt }
    }

    var isEmpty: Bool {
        return message.trim().isEmpty
    }

    func addChat() {
        if !isEmpty {
            store.send(
                .addChat(
                    order: order,
                    message: message
                )
            )
            message = ""
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if let courier = order.courier {
                HStack(spacing: .s1) {
                    HStack(spacing: .s1) {
                        BackButton { path = path.dropLast() }

                        if let image = courier.image {
                            NetworkImage(image: image, width: .s4, height: .s4)
                                .clipShape(
                                    CornerRadiusShape(
                                        radius: .s4,
                                        corners: .allCorners
                                    )
                                )
                        }
                        else {
                            RoundedRectangle(cornerRadius: .s4)
                                .fill(.brandGrayLight)
                                .frame(width: .s4, height: .s4)
                        }
                    }

                    VStack(spacing: 0) {
                        TextRegular("Courier")
                        TextSemiBold("\(courier.firstName) \(courier.lastName)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    IconButton(icon: .phone) { print("call") }
                }
                .frame(maxWidth: .infinity)
                .padding(.all, .s2)
                .background(.white)
                .compositingGroup()
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                ScrollView(.vertical) {
                    ScrollViewReader { reader in
                        VStack(spacing: .s2) {
                            ForEach(chats, id: \.id) { chat in
                                ChatMessage(chat: chat).id(chat.id)
                            }
                        }
                        .onChange(
                            of: chats.count,
                            {
                                reader.scrollTo(chats.last?.id)
                            }
                        )
                        .onAppear(perform: {
                            reader.scrollTo(chats.last?.id)
                        })
                        .padding(.all, .s2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ToggleButtonBar(
                    options: [
                        "Okay 👍🏻", "Thanks 👌🏻", "Be carefull 😁", "Haha", "Ok!",
                        "Perfect!",
                    ],
                    selected: ""
                ) { msg in message = msg }
                .padding(.top, .s2)

                HStack(spacing: 0) {
                    TextField("Enter your message", text: $message)
                        .font(.brandRegular(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .s6)
                        .padding(.horizontal, .s2)
                        .background(
                            CornerRadiusShape(
                                radius: .s1,
                                corners: [.bottomLeft, .topLeft]
                            )
                            .fill(.white)
                        )
                        .focused($isFocused)
                        .keyboardType(.default)
                        .onSubmit {
                            addChat()
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(false)

                    Button {
                        addChat()
                    } label: {
                        Icon(
                            icon: .submit,
                            background: .clear,
                            foreground: .white
                        )
                    }
                    .frame(width: .s6, height: .s6)
                    .disabled(isEmpty)
                    .background(
                        CornerRadiusShape(
                            radius: .s1,
                            corners: [.bottomRight, .topRight]
                        )
                        .fill(.brandPrimary)
                    )
                }
                .padding(.horizontal, .s2)
                .padding(.vertical, .s2)
            }
        }
        .background(.brandGrayLight)
        .toolbar(.hidden, for: .navigationBar)
        .task { store.send(.getOrder(order)) }
    }
}
