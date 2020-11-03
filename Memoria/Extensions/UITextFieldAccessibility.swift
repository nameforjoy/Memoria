//
//  UITextFieldAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 03/11/20.
//

import Foundation

import UIKit

extension UITextField {

    ///Configuration to enable multiple lines and  update font size in real time according to dynamic type acessibility settings
    var dynamicFont: UIFont {
        get {
            return self.font ?? UIFont()
        }
        set {
             if #available(iOS 10.0, *) {
                // Real-time size update
                self.adjustsFontForContentSizeCategory = true
             }
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }
    }
}
