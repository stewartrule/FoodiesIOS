import SwiftUI

struct MultiToggleButtonBar<T: Equatable & Hashable>: View {
    var options: [T]
    var selected: [T]
    var label: (T) -> String = { String(describing: $0) }
    var onSelect: (T) -> Void
    var scrollPadding: Double = .s2

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .s1) {
                ForEach(options, id: \.self) { option in
                    ToggleButton(
                        selected: selected.contains(option),
                        label: label(option)
                    ) { onSelect(option) }
                }
            }
            .padding(.vertical, 0).padding(.horizontal, scrollPadding)
        }
    }
}
