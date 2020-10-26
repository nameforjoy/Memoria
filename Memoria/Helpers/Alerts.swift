//
//  Alerts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class Alerts {
    
    // Memory has been successfully saved
    var memorySaved: UIAlertController {
        // Text
        let title: String = "Sua memória foi guardada!"
        let message: String = "Está disponível para ser acessada e gerar boas lembranças"
        let myalert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Buttons
        let actionTitle = "OK"
        myalert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        return myalert
    }
    
}
