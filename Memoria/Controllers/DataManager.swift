//
//  DataManager.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 08/10/20.
//

import Foundation
import CloudKit

class DataManager {
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    public func save(memory: Memory) {
        let record = CKRecord(recordType: "Memory")
        
        record.setValue(memory.title, forKey: "title")
        record.setValue(memory.description, forKey: "description")
        record.setValue(memory.date, forKey: "date")
        
        self.privateDatabase.save(record) { (savedRecord, error) in
            
            if error == nil {
                print("Record Saved")
            } else {
                print("Record Not Saved")
                print(error)
            }
            
        }
    }


    // This method is not workinng -- Maybe we'll need to use a closure instead of a return
    public func retrieveAllMemories() -> [Memory] {
        var allMemories = [Memory]()

        let predicate = NSPredicate(value: true)

        let query = CKQuery(recordType: "Memory", predicate: predicate)
        //query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            if let title = record["title"] as? String,
               let description = record["description"] as? String,
               let date = record["date"] as? Date {
                let newMemory = Memory(title: title, description: description, date: date)
                allMemories.append(newMemory)
            }

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {

                //return allMemories
                for memory in allMemories {
                    print(memory.title)
                }
            }

        }

        privateDatabase.add(operation)

        return allMemories
    }
}
