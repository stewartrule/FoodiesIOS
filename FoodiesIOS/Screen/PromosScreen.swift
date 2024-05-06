import SwiftUI
import ComposableArchitecture

struct PromosScreen: View {
    let store: StoreOf<RootReducer>

    @Binding var path: [RootPath]

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .s2) {
                VerticalTicket().padding(.horizontal, .s2)
                HorizontalTicket().padding(.horizontal, .s2)
            }
            .padding(.vertical, .s2)
        }
    }
}
