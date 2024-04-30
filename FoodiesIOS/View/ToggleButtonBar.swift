import SwiftUI

struct ToggleButtonBar<T: Equatable & Hashable>: View {
    var options: [T]
    var selected: T
    var label: (T) -> String = { String(describing: $0) }
    var scrollPadding: Double = .s2
    var onSelect: (T) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    ToggleButton(
                        selected: selected == option,
                        label: label(option)
                    ) { onSelect(option) }
                }
            }
            .padding(.vertical, 0)
            .padding(.horizontal, scrollPadding)
        }
    }
}
