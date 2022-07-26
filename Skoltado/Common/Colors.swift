//
//  Colors.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 24.07.2022.
//

import Foundation
import UIKit

enum Colors {
    static let white = UIColor(hex: "#F7F3F5")!
    static let orange = UIColor(hex: "#D64933")!
    static let lightBlue = UIColor(hex: "#92DCE5")!
    static let black = UIColor(hex: "#2B303A")!
    static let gray = UIColor(hex: "#7C7C7C")!
}

extension UIColor {
    convenience init?(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return nil
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
