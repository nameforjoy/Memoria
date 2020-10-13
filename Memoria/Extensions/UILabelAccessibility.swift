//
//  UILabel+Accessibility.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/10/20.
//

import UIKit

extension UILabel {
    
    ///Configuration to enable multiple lines and  update font size in real time according to dynamic type acessibility settings
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
