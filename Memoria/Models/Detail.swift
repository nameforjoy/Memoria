//
//  Detail.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation
import CloudKit

class Detail: Codable {
//    let audio: CKAsset?  //need to import CloudKit for this format but does not conform to protocol 'Codable'
//    let image: CKAsset?
    let text: String?
    let title: String?
    let question: String?
    
    init(text: String, title: String, question: String) {
        self.text = text
        self.title = title
        self.question = question
    }
    
}
