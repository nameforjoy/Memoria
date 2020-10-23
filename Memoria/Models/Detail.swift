//
//  Detail.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation
import CloudKit

class Detail {
    var audio: URL?
    var image: CKAsset?
    var text: String?
    var question: String?

    init(text: String?, question: String?, audio: URL?, image: CKAsset?) {
        self.text = text
        self.question = question
        self.audio = audio
        self.image = image
    }
    
}
