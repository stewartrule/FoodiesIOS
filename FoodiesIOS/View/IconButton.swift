import SwiftUI

enum IconType: String {
    case phone = "phone.fill"
    case bubble = "ellipsis.bubble.fill"
    case plus = "plus"
    case minus = "minus"
    case cutlery = "fork.knife"
    case calendar = "calendar"
    case ticket = "ticket"
    case eye = "eye.fill"
    case eyeSlash = "eye.slash.fill"
    case notification = "bell.fill"
    case chevronRight = "chevron.right"
    case chevronLeft = "chevron.left"
    case submit = "paperplane.fill"
    case profile = "person.fill"
}

struct IconButton: View {
    var icon: IconType = .phone
    var background: Color = .brandPrimary
    var foreground: Color = .brandPrimaryLight
    var size: Double = .s4
    var iconSize: Image.Scale = .small
    var disabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Icon(
                icon: icon,
                background: background,
                foreground: foreground,
                size: size,
                iconSize: iconSize
            )
        }
        .disabled(disabled)
    }
}

struct Icon: View {
    var icon: IconType = .phone
    var background: Color = .brandPrimary
    var foreground: Color = .brandPrimaryLight
    var size: Double = .s4
    var iconSize: Image.Scale = .small

    var body: some View {
        RoundedRectangle(cornerRadius: size).fill(background)
            .frame(width: size, height: size)
            .overlay(alignment: .center) {
                Image(systemName: icon.rawValue).imageScale(iconSize)
                    .foregroundColor(foreground)
            }
    }
}
