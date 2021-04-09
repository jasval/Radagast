//
//  UIColor+Ext.swift
//  Radagast
//
//  Created by Jasper Valdivia on 09/04/2021.
//

import UIKit

extension UIColor {
    
    // MARK: - Theme Constants
    static let aDarkBlue = UIColor(hexString: "#0A2239")
    static let aBlue = UIColor(hexString: "#32709F")
    static let aBrightBlue = UIColor(hexString: "#0F8B8D")
    static let aBoneWhite = UIColor(hexString: "#D6D5C9")
    static let aLightGray = UIColor(hexString: "#CBCBD4")
    static let aDarkMaroon = UIColor(hexString: "#26272B")
    
    enum ThemeElement {
        case logo
        case header
        case text
        case link
        case buttonBackground
        case buttonText
        case overlay
        case accent
        case background
    }
    
    // MARK: - Functions
    
    /// Convenience method to return a color from a hex formatted string
    /// - Parameters:
    ///   - hexString: String (hexformatted with or without the '#' symbol
    ///   - alpha: alpha channel or opacity(transparency) of color.
    public convenience init(hexString hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }

    // This can be extended to a computable variable as an extension of different views
    static func getDynamicColorFor(_ element: UIColor.ThemeElement) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (tc: UITraitCollection) -> UIColor in
                switch element {
                case .logo, .header, .buttonBackground:
                    return tc.userInterfaceStyle == .dark ? .aBlue : .aDarkBlue
                case .link, .accent:
                    return tc.userInterfaceStyle == .dark ? .aBrightBlue : .aBlue
                case .overlay:
                    return tc.userInterfaceStyle == .dark ? .aLightGray : .aBrightBlue
                case .text:
                    return tc.userInterfaceStyle == .dark ? .aLightGray : .aDarkMaroon
                case .buttonText, .background:
                    return tc.userInterfaceStyle == .dark ? .aDarkMaroon : .aLightGray
                }
            }
        } else {
            switch element {
            case .logo, .header, .buttonBackground:
                return .aDarkBlue
            case .link, .accent:
                return .aBlue
            case .overlay:
                return .aBrightBlue
            case .text:
                return .aDarkMaroon
            case .buttonText, .background:
                return .aLightGray
            }
        }
    }
    
}
