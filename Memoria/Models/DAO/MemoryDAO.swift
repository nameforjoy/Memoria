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

    static public func create(memory: Memory, completion: @escaping (Error?) -> Void) {
        let record = CKRecord(recordType: "Memory")

        // Simple record setup
        record.setValue(memory.title, forKey: "title")
        record.setValue(memory.description, forKey: "description")
        record.setValue(memory.date, forKey: "date")

        // Converts UUID to String
        let memoryIDAsString = memory.memoryID.uuidString
        record.setValue(memoryIDAsString, forKey: "memoryID")

        // Converts Bool to NSNumber
        let hasDateAsNumber = NSNumber(value: memory.hasDate)
        record.setValue(hasDateAsNumber, forKey: "hasDate")

        self.privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                print("Record Saved")
                completion(nil)
            } else {
                print("Record Not Saved")
                print(error ?? "Nil")
                completion(error)
            }
        }
    }

    /// Retrieve all memories from database
    static public func findAll(completion: @escaping ([Memory]) -> Void) {
        var allRecords = [Memory]()

        let predicate = NSPredicate(value: true)

        //let predicate = NSPredicate(format: "detailID == %@", objectID as CVarArg)

        let query = CKQuery(recordType: "Memory", predicate: predicate)

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            if let newRecord = self.getMemoryFromRecord(record: record) {
                allRecords.append(newRecord)
            } else {
                print("Record #\(record.recordID) was not able to be converted into a Memory. Check if record has all data necessary.")
                print(record.allKeys())
                print(record.allTokens())
            }

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {
                completion(allRecords)
            }

        }

        privateDatabase.add(operation)
    }

    /// Method to convert a Cloud Kit Record into a Memory
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

        // Converting Texts
        let title = record["title"] as? String
        let description = record["description"] as? String
        let date = record["date"] as? Date

        // Converts iCloud types to model types
        guard let memoryUUID = UUID(uuidString: memoryIDAsString) else {
            print("Invalid String for creating UUID.")
            return nil
        }
        let hasDate = Bool(truncating: hasDateAsNumber as NSNumber)

        // Make Memory object from query results
        let newMemory = Memory(memoryID: memoryUUID, title: title, description: description, hasDate: hasDate, date: date)

        return newMemory
    }
}
