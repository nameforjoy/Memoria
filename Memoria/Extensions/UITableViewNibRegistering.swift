//
//  UITableViewNibRegistering.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit

extension UITableView {
    
    func registerNib(nibIdentifier: NibIdentifier,_ bundle: Bundle? = nil) {
        let nib = UINib.init(nibName: nibIdentifier.rawValue, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: nibIdentifier.rawValue)
    }
}
