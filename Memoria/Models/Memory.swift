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
    let timePassedBy: Int?
    let timeUnit: String?

    // This is only to be used when ordering memories on the UI
    // Every label on the UI uses timePassedBy and timeUnit instead
    var date: Date? {
            return DateManager.getEstimatedDate(timePassedBy: self.timePassedBy, timeUnit: self.timeUnit)
    }

    // Initialize class with existing UUID
    init(memoryID: UUID, title: String, description: String, hasDate: Bool, timePassedBy: Int?, timeUnit: String?) {
        self.memoryID = memoryID
        self.title = title
        self.description = description
        self.hasDate = hasDate
        self.timeUnit = timeUnit
        self.timePassedBy = timePassedBy
    }

    // Initialize class without existing UUID
    init(title: String, description: String, hasDate: Bool, timePassedBy: Int?, timeUnit: String?) {
        self.memoryID = UUID()
        self.title = title
        self.description = description
        self.hasDate = hasDate
        self.timeUnit = timeUnit
        self.timePassedBy = timePassedBy
    }
    
}
