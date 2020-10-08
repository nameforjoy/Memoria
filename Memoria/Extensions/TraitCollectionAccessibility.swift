//
//  TraitCollectionAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UITraitCollection {
    
    var isAccessibleCategory: Bool {
        if #available(iOS 11, *) {
            return preferredContentSizeCategory.isAccessibilityCategory
        } else {
            switch preferredContentSizeCategory {
            case .accessibilityExtraExtraExtraLarge,
                 .accessibilityExtraExtraLarge,
                 .accessibilityExtraLarge,
                 .accessibilityLarge,
                 .accessibilityMedium:
                return true
            default:
                return false
            }
        }
    }
}
