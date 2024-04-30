import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 4)
                .fill(.clear)
                .frame(width: 16, height: 32)
                .overlay(alignment: .center) {
                    Image(systemName: "arrow.backward")
                        .imageScale(.small)
                        .foregroundColor(.primary)
                }
        }
    }
}
