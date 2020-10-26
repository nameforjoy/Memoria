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
    
    /// Apply gradient in the button background
    func applyGradient(colors: [CGColor]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        // Double height of gradient layer (in relation to its bounds) to give space for the button to grow with a dynamic font
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: 2 * self.bounds.height)
        
        // Restrict (cip) gradient layer to button's bounds
        self.clipsToBounds = true
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
