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

        record.setValue(memory.title, forKey: "title")
        record.setValue(memory.description, forKey: "description")
        record.setValue(memory.date, forKey: "date")

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

            if let title = record["title"] as? String,
               let description = record["description"] as? String,
                let date = record["date"] as? Date {
                let newMemory = Memory(title: title, description: description, date: date)
                allRecords.append(newMemory)
                print(newMemory.text)
            }

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {
                completion(allRecords)
            }

        }

        privateDatabase.add(operation)
    }
}
