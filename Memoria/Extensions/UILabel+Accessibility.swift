//
//  UILabel+Accessibility.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/10/20.
//

import UIKit

extension UILabel {
    
    ///Configuration to enable multiple lines, to update in real time and to call the property that enable the font to scale large size
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
