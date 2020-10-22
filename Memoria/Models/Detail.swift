//
//  Detail.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation
import CloudKit

class Detail: Codable {
    var audio: Data?
    var text: String?
    var question: String?

    init(text: String?, question: String?, audio: Data?) {
        self.text = text
        self.question = question
        self.audio = audio
    }
    
}
