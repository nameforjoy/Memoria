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

    static public func create(detail: Detail) {
        
        // Turn Detail values into a CKRecord object to be recorded
        let record = CKRecord(recordType: "Detail")

        record.setValue(detail.question, forKey: "question")
        record.setValue(detail.text, forKey: "text")

        if let imageURL = detail.image {
            let imageCKAsset = CKAsset(fileURL: imageURL)
            record.setValue(imageCKAsset, forKey: "image")
        }

        if let audioURL = detail.audio {
            let audioCKAsset = CKAsset(fileURL: audioURL)
            record.setValue(audioCKAsset, forKey: "audioAsset")
        }

        // Record detail in iCloud's private database
        self.privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                print("Record Saved")
                print(savedRecord?.object(forKey: "question") ?? "Nil")
                print(savedRecord?.object(forKey: "text") ?? "Nil")
                print(savedRecord?.object(forKey: "audioAsset") ?? "Nil")
            } else {
                print("Record Not Saved")
                print(error ?? "Nil")
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

            // Make Detail object from query results
            let text = record["text"] as? String
            let question = record["question"] as? String
            let audio = record["audioAsset"] as? CKAsset
            let audioURL = audio?.fileURL
            let image = record["image"] as? CKAsset
            let imageURL = image?.fileURL
            let newDetail = Detail(text: text, question: question, audio: audioURL, image: imageURL)
            allRecords.append(newDetail)
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                completion(allRecords)
            }
        }
        
        privateDatabase.add(operation)
    }
    
}
