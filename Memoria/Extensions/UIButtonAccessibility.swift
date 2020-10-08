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
}
