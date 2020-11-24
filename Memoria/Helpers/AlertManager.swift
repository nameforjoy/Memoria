//
//  Alerts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//
// For more precise URL redirectings (for example, go to iCloud Settings), see:
// https://www.macstories.net/ios/a-comprehensive-guide-to-all-120-settings-urls-supported-by-ios-and-ipados-13-1/
//

import Foundation
import UIKit

protocol AlertManagerDelegate: AnyObject {
    func buttonAction()
}

class AlertManager {
    
    weak var delegate: AlertManagerDelegate?
    
    // Memory has been successfully saved
    var memorySaved: UIAlertController {
        
        let title: String = "Sua memória foi guardada!"
        let message: String = "Está disponível para ser acessada e gerar boas lembranças"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (_) in
            self.delegate?.buttonAction()
        }

        myAlert.addAction(okButton)
        
        return myAlert
    }
    
    // Allow access to microphone in Settings to preoceed
    var changeMicrophonePermission: UIAlertController {
        
        let title = "Ops, não temos acesso ao seu microfone!"
        let message = "Para gravarmos seu áudio precisamos que você nos permita esse acesso, o que você pode fazer nas Configurações do seu iPhone"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Go to settings
        myAlert.addAction(UIAlertAction(title: "Ir para Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        // Cancel
        myAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        return myAlert
    }
    
    var unableToSave: UIAlertController {
        let title = "Ops, não podemos salvar sua resposta assim!"
        let message = "Preencha ao menos um dos campos"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return myAlert
    }
    
    var giveTitleToSave: UIAlertController {
        let title = "Ops, não podemos salvar sua memória assim!"
        let message = "Insira um título para que possamos prosseguir"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return myAlert
    }
    
    var userNotAuthenticated: UIAlertController {
        let title = "Usuário não autenticado"
        let message = "Verifique seu login iCloud para que possamos prosseguir!"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK button
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Go to settings
        myAlert.addAction(UIAlertAction(title: "Ir para Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))

        return myAlert
    }
    
    var storageQuotaExceeded: UIAlertController {
        let title = "Sem espaço no iCloud"
        let message = "Guardamos suas memórias no iCloud, então libere espaço de armazenamento para podermos prosseguir!"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK button
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Go to settings
        myAlert.addAction(UIAlertAction(title: "Ir para Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))

        return myAlert
    }
    
    func makeServiceUnavailableAlert(typeMessage: String) -> UIAlertController {
        let title = "Ops!"
        let message = "Tivemos algum problema com o armazenamento das suas memórias. Tente novamente mais tarde. " + typeMessage
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        return myAlert
    }
    
    func makePoorNetworkConnectionAlert(message: String? = nil) -> UIAlertController {
        let title = "Sem acesso a internet"
        let myMessage: String = message ?? "Não conseguimos acessar os servidores. Cheque sua conexão com a internet e tente novamente!"
        let myAlert = UIAlertController(title: title, message: myMessage, preferredStyle: .alert)
        
        // OK button
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Go to settings
        myAlert.addAction(UIAlertAction(title: "Ir para Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        return myAlert
    }
    
    func makeReachedAudioTimeLimitAlert(_ completion: @escaping () -> Void) -> UIAlertController {
        let title = "Limite de tempo atingido"
        let message = "Paramos sua gravação pois o áudio atingiu o tempo máximo permitido."
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Pause audio recording and dismiss view
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        return myAlert
    }
    
    func makeStorageQuotaCheckAlert(_ completion: @escaping () -> Void) -> UIAlertController {
        let title = "Atenção"
        let message = "Verifique se possui espaço livre de armazenamento no iCloud, pois é lá que guardaremos suas memórias para sua segurança!"
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Procceed to add new memory
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        // Go to settings
        myAlert.addAction(UIAlertAction(title: "Ir para Configurações", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        // Don't show again
        myAlert.addAction(UIAlertAction(title: "Não mostrar novamente", style: .default, handler: { _ in
            let userDefault = UserDefaults.standard
            userDefault.set(true, forKey: "shouldNotDisplayStorageAlert") // save true flag to UserDefaults
            userDefault.synchronize()
            completion()
        }))
        return myAlert
    }
}
