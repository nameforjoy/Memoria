//
//  MemoryServices.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 05/11/20.
//

import Foundation

class MemoryServices {

    static public func createMemory(title: String?, hasDate: Bool, timePassedBy: Int?, timeUnit: Calendar.Component?, description: String?) {

        var estimatedDate: Date?

        if hasDate {
            estimatedDate = DateManager.getEstimatedDate(timePassedBy: timePassedBy, timeUnit: timeUnit)
        } else {
            estimatedDate = nil
        }

        let newMemory = Memory(title: title, description: description, hasDate: hasDate, date: estimatedDate)

        MemoryDAO.create(memory: newMemory)
    }
}
