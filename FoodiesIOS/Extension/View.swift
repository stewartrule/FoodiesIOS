import SwiftUI

struct CornerRadiusShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

typealias RotationHandler = (
    _ orientation: UIDeviceOrientation, _ screen: CGRect, _ safeArea: EdgeInsets
) -> Void

struct DeviceRotationViewModifier: ViewModifier {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    let action: RotationHandler

    func body(content: Content) -> some View {
        content.onAppear()
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                )
            ) { _ in
                action(
                    UIDevice.current.orientation,
                    UIApplication.shared.currentWindow?.screen.bounds
                        ?? UIScreen.main.bounds,
                    safeAreaInsets
                )
            }
    }
}

extension View {
    func onRotate(perform action: @escaping RotationHandler) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

typealias ResponsiveInsetsHandler = (
    _ safeArea: EdgeInsets, _ orientation: UIDeviceOrientation, _ screen: CGRect
) -> EdgeInsets

struct ResponsivePadding: ViewModifier {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var orientation = UIDeviceOrientation.portrait

    let merge: ResponsiveInsetsHandler

    init(_ merge: @escaping ResponsiveInsetsHandler) {
        self.orientation =
            UIDevice.current.orientation.isLandscape
            ? .landscapeLeft : .portrait

        self.merge = merge
    }

    func body(content: Content) -> some View {
        content.padding(
            merge(
                safeAreaInsets,
                orientation,
                UIApplication.shared.currentWindow?.screen.bounds
                    ?? UIScreen.main.bounds
            )
        )
        .onRotate { newOrientation, _, _ in orientation = newOrientation }
    }
}

extension View {
    func padding(_ merge: @escaping ResponsiveInsetsHandler) -> some View {
        modifier(ResponsivePadding(merge))
    }
}

typealias SizeHandler = (
    _ screen: CGRect, _ orientation: UIDeviceOrientation, _ safeArea: EdgeInsets
) -> Double

struct WidthModifier: ViewModifier {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var orientation = UIDeviceOrientation.portrait

    let handle: SizeHandler

    init(_ handle: @escaping SizeHandler) {
        self.orientation =
            UIDevice.current.orientation.isLandscape
            ? .landscapeLeft : .portrait

        self.handle = handle
    }

    func body(content: Content) -> some View {
        content.frame(
            width: handle(
                UIApplication.shared.currentWindow?.screen.bounds
                    ?? UIScreen.main.bounds,
                orientation,
                safeAreaInsets
            )
        )
        .onRotate { newOrientation, _, _ in orientation = newOrientation }
    }
}

extension View {
    func width(_ handle: @escaping SizeHandler) -> some View {
        modifier(WidthModifier(handle))
    }
}
