//
//  UIColor+Extensions.swift
//
//
//  Created by Anthony on 9/9/24.
//

import Foundation
import UIKit
import SwiftUI

public extension UIColor {
    
    /// Initializes a UIColor object using a hex string.
    ///
    /// This initializer supports hex strings in RGB (12-bit, 24-bit) and ARGB (32-bit) formats.
    ///
    /// - Parameter hexString: The hex string representing the color.
    ///   - Example: "FF5733" or "#FF5733" for RGB (24-bit), "AABBCC" for ARGB (32-bit).
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default to black if hex format is invalid
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    /// Initializes a UIColor object using an RGB integer value.
    ///
    /// - Parameter rgbValue: The RGB integer value (e.g., 0xFF5733).
    ///   The integer should represent a 24-bit RGB color.
    convenience init(rgbValue: Int) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Converts the UIColor to SwiftUI's `Color`.
    ///
    /// - Returns: A `Color` object based on the current `UIColor`.
    var color: Color {
        Color(self)
    }
}
