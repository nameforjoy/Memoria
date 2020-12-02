//
//  UIViewGradient.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 01/12/20.
//

import UIKit

extension UIView {
    /// Apply gradient in the button background
    func applyGradient(colors: [CGColor]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        // Double height of gradient layer (in relation to its bounds) to give space for the button to grow with a dynamic font
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width * 1.5, height: 2 * self.bounds.height)
        
        // Restrict (cip) gradient layer to button's bounds
        self.clipsToBounds = true
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
