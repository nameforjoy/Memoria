//
//  Detail.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation
import CloudKit

class Detail: Codable {
    var audio: Data?  // need to import CloudKit for this format but does not conform to protocol 'Codable'
//    let image: String?
    var text: String?
    var question: String?
    
    init(text: String, question: String) {
        self.text = text
        self.question = question
    }

    init(text: String?, question: String?, audio: Data?) {
        self.text = text
        self.question = question
        self.audio = audio
    }
    
}
