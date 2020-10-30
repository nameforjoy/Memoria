//
//  PresentationManager.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 29/10/20.
//

import UIKit

class PresentationManager {
    
    func presentAsModal(show viewController: UIViewController, over context: UIViewController) {
        
        // Set up presentation mode
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Set up background to mimic the iOS native Alert
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Present alert
        context.present(viewController, animated: true, completion: nil)
    }
}
