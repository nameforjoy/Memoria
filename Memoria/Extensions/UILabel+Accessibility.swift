//
//  UILabel+Accessibility.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/10/20.
//

import UIKit

extension UILabel {
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
            return self.font
        }
        
        set {
            self.numberOfLines = 0
            
            if #available(iOS 10.0, *) {
                // Real-time size update
                self.adjustsFontForContentSizeCategory = true
            }
            
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }
    }
}
