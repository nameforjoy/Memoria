//
//  ScrollViewKeyboard.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 08/10/20.
//

import UIKit

extension UIScrollView {
    
    /// Changes scroll view offset so that input view is not overlapped by keyboard.
    /// For it to work, the scroll view must be a child of the main view, and the input view must be a child of the scroll view.
    func adjustScrollOffsetToKeyboard(keyboardFrame: CGRect, inputViewFrame: CGRect, spacing: CGFloat = 20) {
        
        // Get scroll view, input view and keyboard key points in Main View Coordinates (MVC)
        let scrollViewFrameTopMVC = self.frame.origin.y
        let scrollViewContentTopMVC = scrollViewFrameTopMVC - self.contentOffset.y
        let activeInputViewTopMVC = inputViewFrame.origin.y + scrollViewContentTopMVC
        let activeInputViewBottomMVC = inputViewFrame.origin.y + inputViewFrame.height + scrollViewContentTopMVC
        let keyboardTopMVC = keyboardFrame.origin.y
        
        // Scroll view area that is visible to the user
        let visibleAreaHeight = keyboardTopMVC - scrollViewFrameTopMVC
        
        // If the input view is not inside the visible area, scroll content untill it is
        if activeInputViewTopMVC < scrollViewFrameTopMVC ||
            activeInputViewBottomMVC > keyboardTopMVC {
            
            print("ActiveField NOT completely inside visible area")
            
            // Tests whether the active input view shold be aligned by its top or bottom
            // Depends on whether its height is bigger than the visible area's or not
            if inputViewFrame.height > visibleAreaHeight {
                // Align top of active field with scrollView frame top
                self.contentOffset.y = inputViewFrame.origin.y - spacing
            } else {
                // Align bottom of active field with keyboard top
                self.contentOffset.y += activeInputViewBottomMVC - keyboardTopMVC
            }
        } else {
            print("ActiveField is completely inside visible area")
        }
    }
}
