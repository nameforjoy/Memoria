//
//  Memory.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 07/10/20.
//

import Foundation

class Memory {
    let memoryID: UUID
    let title: String?
    let description: String?
    let hasDate: Bool
    var date: Date?

    // Initialize class with existing UUID
    init(memoryID: UUID, title: String?, description: String?, hasDate: Bool, date: Date?) {
        self.memoryID = memoryID
        self.title = title
        self.description = description
        self.hasDate = hasDate
        self.date = date
    }

    // Initialize class without existing UUID
    init(title: String?, description: String?, hasDate: Bool, date: Date?) {
        self.memoryID = UUID()
        self.title = title
        self.description = description
        self.hasDate = hasDate
        self.date = date
    }
}
