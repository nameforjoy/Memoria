//
//  UIButtonAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UIButton {

    ///Configuration to enable multiple lines and  update font size in real time according to dynamic type acessibility settings
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
