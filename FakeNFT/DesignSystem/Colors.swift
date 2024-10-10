import UIKit

extension UIColor {
    // MARK: - Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // MARK: - Background Colors
    static let background = UIColor { $0.userInterfaceStyle == .dark ? .ypBlackUniversal : .ypWhiteUniversal }

    // MARK: - Text Colors
    static let textPrimary: UIColor = .ypBlack
    static let textSecondary: UIColor = .ypGreenUniversal
    
    // MARK: - Base Colors
    static let ypGrayUniversal = UIColor(hexString: "625C5C")
    static let ypRedUniversal = UIColor(hexString: "F56B6C")
    static let ypBackgroundUniversal = UIColor(hexString: "1A1B22")
    static let ypGreenUniversal = UIColor(hexString: "1C9F00")
    static let ypBlueUniversal = UIColor(hexString: "0A84FF")
    static let ypBlackUniversal = UIColor(hexString: "1A1B22")
    static let ypWhiteUniversal = UIColor(hexString: "FFFFFF")
    static let ypYellowUniversal = UIColor(hexString: "FEEF0D")
    
    // MARK: - Base Colors Day/Night
    
    private static let ypLightGreyDay = UIColor(hexString: "F7F7F8")
    private static let ypLightGreyNight = UIColor(hexString: "2C2C2E")

    static let ypWhite = UIColor { $0.userInterfaceStyle == .dark ? .ypBlackUniversal : .ypWhiteUniversal }
    
    static let ypBlack = UIColor { $0.userInterfaceStyle == .dark ? .ypWhiteUniversal : .ypBlackUniversal }
    
    static let yplightGrey = UIColor { $0.userInterfaceStyle == .dark ? .ypLightGreyDay : .ypLightGreyNight }
    
    static let ypSegmentActive = UIColor { $0.userInterfaceStyle == .dark ? .ypBlackUniversal : .ypWhiteUniversal }

    static let ypSegmentInactive = UIColor { $0.userInterfaceStyle == .dark ? .ypLightGreyDay : .ypLightGreyNight }

    static let ypCloseButton = UIColor { $0.userInterfaceStyle == .dark ? .ypBlackUniversal : .ypWhiteUniversal }
}
