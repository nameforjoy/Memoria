//
//  Alerts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class Alerts {
    
    var memorySaved: UIAlertController {
        let title: String = "Parabéns"
        let message: String = "Sua memória foi salva"
        let myalert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionTitle = "OK"
        myalert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        return myalert
    }
    
}
