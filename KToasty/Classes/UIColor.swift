//
//  UIColor.swift
//  KToast
//
//  Created by Sơn Lê on 19/11/2023.
//

import Foundation

extension UIColor {
    
    /// Creates a color object using the specified opacity and hex integer RGB component values.
    /// - Parameters:
    ///   - hex: 0xRRGGBB
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha)
        )
    }
}
