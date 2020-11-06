//
//  DetailDAO.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 14/10/20.
//

import Foundation
import CloudKit

class DetailDAO: DAO {

    static let privateDatabase = CKContainer.default().privateCloudDatabase

    static public func create(detail: Detail, completion: @escaping (Error?) -> Void) {
        
        // Turn Detail values into a CKRecord object to be recorded
        let record = CKRecord(recordType: "Detail")

        // Sets text content to record
        record.setValue(detail.question, forKey: "question")
        record.setValue(detail.text, forKey: "text")
        record.setValue(detail.category, forKey: "category")

        // Converts image
        if let imageURL = detail.image {
            let imageCKAsset = CKAsset(fileURL: imageURL)
            record.setValue(imageCKAsset, forKey: "image")
        }

        // Converts audio
        if let audioURL = detail.audio {
            let audioCKAsset = CKAsset(fileURL: audioURL)
            record.setValue(audioCKAsset, forKey: "audioAsset")
        }

        // Record detail in iCloud's private database
        self.privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                // Debug prints
                print("Record Saved")
                print(savedRecord?.object(forKey: "question") ?? "Nil")
                print(savedRecord?.object(forKey: "text") ?? "Nil")
                print(savedRecord?.object(forKey: "audioAsset") ?? "Nil")
                completion(nil)
            } else {
                // TODO: Treat error
                print("Record Not Saved")
                print(error ?? "Nil")
                completion(error)
            }
        }
    }

    //This method is not workinng -- Maybe we'll need to use a closure instead of a return
    static public func findAll(completion: @escaping ([Detail]) -> Void) {
        
        // Fecthed details array
        var allRecords = [Detail]()

        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "detailID == %@", objectID as CVarArg)

        //  Make query operation to fetch a detail
        let query = CKQuery(recordType: "Detail", predicate: predicate)
        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            let newDetail = self.getDetailFromRecord(record: record)

            // Add new detail to array
            allRecords.append(newDetail)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                completion(allRecords)
            }
        }
        
        privateDatabase.add(operation)
    }

    /// Method to retrieve all Details from database related to the same Memory ID
    static public func findByMemoryID(memoryID: UUID, completion: @escaping ([Detail]) -> Void) {
        // Fecthed details array
        var allRecords = [Detail]()

        let predicate = NSPredicate(format: "memoryID == %@", memoryID as CVarArg)

        //  Make query operation to fetch a detail
        let query = CKQuery(recordType: "Detail", predicate: predicate)
        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            let newDetail = self.getDetailFromRecord(record: record)

            // Add new detail to array
            allRecords.append(newDetail)
        }

        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                completion(allRecords)
            }
        }

        privateDatabase.add(operation)
    }

    /// Method to convert CKRecord into a Detail
    static private func getDetailFromRecord(record: CKRecord) -> Detail {
        // Converting Texts
        let text = record["text"] as? String
        let question = record["question"] as? String
        let category = record["category"] as? String

        // Converting Audio
        let audio = record["audioAsset"] as? CKAsset
        let audioURL = audio?.fileURL

        // Converting Image
        let image = record["image"] as? CKAsset
        let imageURL = image?.fileURL

        // Make Detail object from query results
        let newDetail = Detail(text: text, question: question, category: category, audio: audioURL, image: imageURL)

        return newDetail
    }
    
}
