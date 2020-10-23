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
        let record = CKRecord(recordType: "Detail")

        record.setValue(detail.question, forKey: "question")
        record.setValue(detail.text, forKey: "text")

        if let image = detail.image {
            record.setValue(image, forKey: "image")
        }

        if let audioURL = detail.audio {
            let audioCKAsset = CKAsset(fileURL: audioURL)
            record.setValue(audioCKAsset, forKey: "audioAsset")
        }

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
        var allRecords = [Detail]()

        let predicate = NSPredicate(value: true)

        //let predicate = NSPredicate(format: "detailID == %@", objectID as CVarArg)

        let query = CKQuery(recordType: "Detail", predicate: predicate)

        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            let text = record["text"] as? String
            let question = record["question"] as? String
            let audio = record["audioAsset"] as? CKAsset
            let audioURL = audio?.fileURL
            let image = record["image"] as? CKAsset
            let newDetail = Detail(text: text, question: question, audio: audioURL, image: image)
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
