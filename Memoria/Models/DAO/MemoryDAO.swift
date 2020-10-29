//
//  MemoryDAO.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 14/10/20.
//

import Foundation
import CloudKit

class MemoryDAO: DAO {

    static let privateDatabase = CKContainer.default().privateCloudDatabase

    static public func create(memory: Memory) {
        let record = CKRecord(recordType: "Memory")

        // Simple record setup
        record.setValue(memory.title, forKey: "title")
        record.setValue(memory.description, forKey: "description")
        record.setValue(memory.date, forKey: "date")
        record.setValue(memory.timePassedBy, forKey: "timePassedBy")
        record.setValue(memory.timeUnitAsString, forKey: "timeUnit")

        // Converts UUID to String
        let memoryIDAsString = memory.memoryID.uuidString
        record.setValue(memoryIDAsString, forKey: "memoryID")

        // Converts Bool to Int
        let hasDateAsNumber = NSNumber(value: memory.hasDate)
        record.setValue(hasDateAsNumber, forKey: "hasDate")

        self.privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                print("Record Saved")
                print(savedRecord?.object(forKey: "title") ?? "Nil")
                print(savedRecord?.object(forKey: "description") ?? "Nil")
                print(savedRecord?.object(forKey: "date") ?? "Nil")

            } else {
                print("Record Not Saved")
                print(error ?? "Nil")

            }
        }
    }

    //This method is not workinng -- Maybe we'll need to use a closure instead of a return
    static public func findAll(completion: @escaping ([Memory]) -> Void) {
        var allRecords = [Memory]()

        let predicate = NSPredicate(value: true)

        //let predicate = NSPredicate(format: "detailID == %@", objectID as CVarArg)

        let query = CKQuery(recordType: "Memory", predicate: predicate)

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            let newRecord = self.getMemoryFromRecord(record: record)
            allRecords.append(newRecord)

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {
                completion(allRecords)
            }

        }

        privateDatabase.add(operation)
    }

    static private func getMemoryFromRecord(record: CKRecord) -> Memory {

        // Converting Texts
        let title = record["title"] as? String
        let description = record["description"] as? String
        let date = record["date"] as? Date
        let timeBasseBy = record["timePassedBy"] as? Int

        // Converts
        let timeUnitAsString = record["timeUnit"] as? String

        // TODO: Converts String to UUID
//        guard let memoryIDAsString = record["memoryID"] as? String else {return nil}
//        let memoryUUID = UUID(uuidString: memoryIDAsString)


        // TODO: Converts NSNumber to Bool
//        let hasDateAsNumber = record["hasDate"] as? NSNumber
//        let hasDate = Bool(hasDateAsNumber as NSNumber)

        // Make Memory object from query results
        // TODO: Get real information from record
        let newMemory = Memory(memoryID: UUID(), title: "", description: "", hasDate: true, timePassedBy: 3, timeUnit: .day)

        return newMemory
    }
}
