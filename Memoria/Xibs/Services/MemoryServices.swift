//
//  MemoryServices.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 05/11/20.
//

import Foundation

class MemoryServices {

    /// Method to organize information from UI to conform the database.
    /// Case without existing ID.
    static public func create(title: String?, hasDate: Bool, timePassed: Int?, timeUnit: Calendar.Component?, description: String?) {

        var estimatedDate: Date?

        if hasDate {
            estimatedDate = DateManager().getEstimatedDate(timePassed: timePassed, component: timeUnit)
        } else {
            estimatedDate = nil
        }

        let newMemory = Memory(title: title, description: description, hasDate: hasDate, date: estimatedDate)

        MemoryDAO.create(memory: newMemory) { (error) in
            //Present alert "Infelizmente não conseguimos salvar sua memória :("
        }
    }

    // swiftlint:disable function_parameter_count
    /// Method to organize information from UI to conform the database.
    /// Case with existing ID.
    static public func create(memoryId: UUID, title: String?, hasDate: Bool, timePassed: Int?, timeUnit: Calendar.Component?, description: String?) {

        var estimatedDate: Date?

        if hasDate {
            estimatedDate = DateManager().getEstimatedDate(timePassed: timePassed, component: timeUnit)
        } else {
            estimatedDate = nil
        }

        let newMemory = Memory(memoryID: memoryId, title: title, description: description, hasDate: hasDate, date: estimatedDate)

        MemoryDAO.create(memory: newMemory) { (error) in
            //Present alert "Infelizmente não conseguimos salvar sua memória :("
        }
    }

    /// Method to organize data from database before returning to de UI.
    /// Might be a good place to reorder the memory array by date or any other criteria.
    static public func findAll(completion: @escaping ([Memory]) -> Void) {
        MemoryDAO.findAll { (retievedMemories) in
            completion(retievedMemories)
        }
    }
}
