//
//  Detail.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation
import CloudKit

class Detail {

    var memoryID: UUID
    var audio: URL?
    var image: URL?
    var text: String?
    var question: String?
    var category: String?

    init(memoryID: UUID, text: String?, question: String?, category: String?, audio: URL?, image: URL?) {
        self.memoryID = memoryID
        self.text = text
        self.question = question
        self.audio = audio
        self.image = image
        self.category = category
    }
}
