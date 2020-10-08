//
//  UITextViewAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UITextView {

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
