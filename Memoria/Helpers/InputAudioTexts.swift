//
//  InputAudioTexts.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 09/11/20.
//

import Foundation

class InputAudioTexts {
    
    var isAccessibleCategory: Bool = false

    let recordAudioSubtitle: String = "Ao pressionar o botão a gravação será iniciada."
    
    var recordAudioTitle: String {
        if self.isAccessibleCategory {
            return "Podemos gravar?"
        } else {
            return "Podemos começar a gravar?"
        }
    }
}
