import SwiftUI

struct PromosScreen: View {
    @Binding var store: RootStore

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
