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
        record.setValue(memory.timeUnit, forKey: "timeUnit")

        // Converts Int to NSNumber
        if let timePassedBy = memory.timePassedBy {
            let timePassedByAsNumber = NSNumber(integerLiteral: timePassedBy)
            record.setValue(timePassedByAsNumber, forKey: "timePassedBy")
        }

        // Converts UUID to String
        let memoryIDAsString = memory.memoryID.uuidString
        record.setValue(memoryIDAsString, forKey: "memoryID")

        // Converts Bool to NSNumber
        let hasDateAsNumber = NSNumber(value: memory.hasDate)
        record.setValue(hasDateAsNumber, forKey: "hasDate")

        self.privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                print("Record Saved")
            } else {
                print("Record Not Saved")
                print(error ?? "Nil")

            }
        }
    }

    // *** INCOMPLETE METHOD ***
    //This method is not workinng -- Maybe we'll need to use a closure instead of a return
    static public func findAll(completion: @escaping ([Memory]) -> Void) {
        var allRecords = [Memory]()

        let predicate = NSPredicate(value: true)

        //let predicate = NSPredicate(format: "detailID == %@", objectID as CVarArg)

        let query = CKQuery(recordType: "Memory", predicate: predicate)

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            let newRecord = self.getMemoryFromRecord(record: record)
            // allRecords.append(newRecord)

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {
                completion(allRecords)
            }

        }

        privateDatabase.add(operation)
    }

    static private func getMemoryFromRecord(record: CKRecord) -> Memory? {

        // Casting record value to String
        guard let memoryIDAsString = record["memoryID"] as? String else {
            print("Couldn't cast memoryIDAsString record as a string.")
            return nil
        }

        // Casting record value to NSNumber
        guard let hasDateAsNumber = record["hasDate"] as? NSNumber else {
            print("Couldn't cast hasDateAsNumber record as a NSNumber.")
            return nil
        }

        // Casting record value to NSNumber
        guard let timePassedByAsNumber = record["timePassedBy"] as? NSNumber else {
            print("Couldn't cast timePassedByAsNumber record as a NSNumber.")
            return nil
        }

        // Converting Texts
        guard let title = record["title"] as? String else { return nil }
        guard let description = record["description"] as? String else { return nil }
        let date = record["date"] as? Date
        let timeUnit = record["timeUnit"] as? String

        // Converts iCloud types to model types
        guard let memoryUUID = UUID(uuidString: memoryIDAsString) else { return nil }
        let hasDate = Bool(truncating: hasDateAsNumber as NSNumber)
        let timePassedBy = Int(truncating: timePassedByAsNumber)

        // Make Memory object from query results
        let newMemory = Memory(memoryID: memoryUUID, title: title, description: description, hasDate: hasDate, timePassedBy: timePassedBy, timeUnit: timeUnit)

        return newMemory
    }
}
