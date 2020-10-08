//
//  UITextViewAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UITextView {

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

    var dynamicFont: UIFont {
        get {
            return self.font ?? UIFont()
        }
        set {
            self.textAlignment = .center

             if #available(iOS 10.0, *) {
                // Real-time size update
                self.adjustsFontForContentSizeCategory = true
             }

            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }
    }
}
