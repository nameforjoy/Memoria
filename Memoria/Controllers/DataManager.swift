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
    var titles = [String]()
    var recordIDs = [CKRecord.ID]()
    
    public func save() {
        let title = "Tentativa 2"
        
        let record = CKRecord(recordType: "Memory")
        
        record.setValue(title, forKey: "title")
        
        self.privateDatabase.save(record) { (savedRecord, error) in
            
            if error == nil {
                
                print("Record Saved")
                print(savedRecord?.allKeys())
                print(savedRecord?.allTokens())
                
            } else {
                
                print("Record Not Saved")
                print(error)
                
            }
            
        }
    }
    
    public func retrieve() {
        let predicate = NSPredicate(value: true)

        let query = CKQuery(recordType: "Memory", predicate: predicate)
        //query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]

        let operation = CKQueryOperation(query: query)

        titles.removeAll()
        recordIDs.removeAll()

        operation.recordFetchedBlock = { record in

            print(record.allKeys())
            print(record.allTokens())
            self.titles.append(record["title"]!)
            self.recordIDs.append(record.recordID)

        }

        operation.queryCompletionBlock = { cursor, error in

            DispatchQueue.main.async {

                print("Titles: \(self.titles)")
                print("RecordIDs: \(self.recordIDs)")

            }

        }

        privateDatabase.add(operation)

    }
}
