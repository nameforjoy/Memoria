//
//  TraitCollectionAccessibility.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import UIKit

extension UITraitCollection {
    
    /// Tells whether dynamic type font size is an acessibility category
    var isAccessibleCategory: Bool {
        if #available(iOS 11, *) {
            return preferredContentSizeCategory.isAccessibilityCategory
        } else {
            // Manually set the acessibility categories for earlier iOS versions
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
