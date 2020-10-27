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
        
        let title: String = "Sua memória foi guardada!"
        let message: String = "Está disponível para ser acessada e gerar boas lembranças"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionTitle = "OK"
        myAlert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        
        return myAlert
    }
    
    // Allow access to microphone in Settings to preoceed
    var changeMicrophonePermission: UIAlertController {
        
        let title = "Ops, não temos acesso ao seu microfone"
        let message = "Para gravarmos seu áudio precisamos que você nos permita esse acesso, o que você pode fazer nas Configurações do seu iPhone"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        myAlert.addAction(UIAlertAction(title: "Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        myAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        return myAlert
    }
}