import SwiftUI

extension Font {
    static func brandLight(size: CGFloat = 14) -> Font {
        return .custom("Poppins-Light", size: size)
    }

    static func brandRegular(size: CGFloat = 14) -> Font {
        return .custom("Poppins-Regular", size: size)
    }

    static func brandSemiBold(size: CGFloat = 14) -> Font {
        return .custom("Poppins-SemiBold", size: size)
    }

    static func brandBold(size: CGFloat = 14) -> Font {
        return .custom("Poppins-Bold", size: size)
    }
}
