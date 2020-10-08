//
//  UIButtonAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UIButton {

    var dynamicFont: UIFont {
        get {
            return self.titleLabel?.font ?? UIFont()
        }
        set {
            self.titleLabel?.dynamicFont = newValue

            self.titleLabel?.textAlignment = .center
            self.titleLabel?.lineBreakMode = .byWordWrapping
        }
    }

    @IBInspectable var dynamicTheme: String {
        get {
            return self.dynamicTheme
        }
        set {
            let fontName = newValue.components(separatedBy: "_")[0]
            let fontSize = CGFloat(Int(newValue.components(separatedBy: "_")[1]) ?? 17)

            let newFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            self.dynamicFont = newFont
        }
    }
}
