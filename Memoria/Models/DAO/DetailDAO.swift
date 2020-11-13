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

        // Converts UUID to String
        let memoryIDAsString = detail.memoryID.uuidString
        record.setValue(memoryIDAsString, forKey: "memoryID")

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

            // Colocar dispatch.main.async na hora de mostrar o alert de erro
            // (VC com o showError() que os outros vão herdar)
            // Tira necessidade da post notification
            
            if error == nil {
                // Debug prints
                print("Record Saved")
                print(savedRecord?.object(forKey: "question") ?? "Nil")
                print(savedRecord?.object(forKey: "text") ?? "Nil")
                print(savedRecord?.object(forKey: "audioAsset") ?? "Nil")
                completion(nil)
            } else {
                print("Record Not Saved")
                print(error ?? "Unable to print error")
                completion(error)
            }
        }
    }

    //This method is not workinng -- Maybe we'll need to use a closure instead of a return
    static public func findAll(completion: @escaping ([Detail], Error?) -> Void) {
        
        // Fecthed details array
        var allRecords = [Detail]()

        let predicate = NSPredicate(value: true)

        //  Make query operation to fetch a detail
        let query = CKQuery(recordType: "Detail", predicate: predicate)
        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            if let newDetail = self.getDetailFromRecord(record: record) {
                // Add new detail to array
                allRecords.append(newDetail)
            } else {
                print("Record couldn't be converted into Detail")
                print("Record ID: \(record.recordID)")
            }
        }
        
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                completion(allRecords, error)
            }
        }
        
        privateDatabase.add(operation)
    }

    /// Method to retrieve all Details from database related to the same Memory ID
    static public func findByMemoryID(memoryID: UUID, completion: @escaping ([Detail]) -> Void) {
        // Fecthed details array
        var allRecords = [Detail]()

        // Converts UUID to String
        let memoryIDAsString = memoryID.uuidString
        let predicate = NSPredicate(format: "memoryID == %@", memoryIDAsString as CVarArg)

        //  Make query operation to fetch a detail
        let query = CKQuery(recordType: "Detail", predicate: predicate)
        let operation = CKQueryOperation(query: query)

        operation.recordFetchedBlock = { record in

            if let newDetail = self.getDetailFromRecord(record: record) {
                // Add new detail to array
                allRecords.append(newDetail)
            } else {
                print("Record couldn't be converted into Detail")
                print("Record ID: \(record.recordID)")
            }
        }

        operation.queryCompletionBlock = { cursor, error in
            
            if error == nil {
                DispatchQueue.main.async {
                    completion(allRecords)
                }
            } else {
                // TODO: Treat error
                print("Record Not Saved")
                print(error ?? "Unable to print error")
            }
            
        }

        privateDatabase.add(operation)
    }

    /// Method to convert CKRecord into a Detail
    static private func getDetailFromRecord(record: CKRecord) -> Detail? {
        // Casting record value to String
        guard let memoryIDAsString = record["memoryID"] as? String else {
            print("Couldn't cast memoryIDAsString record as a string.")
            return nil
        }

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

        // Converting UUID
        guard let memoryUUID = UUID(uuidString: memoryIDAsString) else {
            print("Invalid String for creating UUID.")
            return nil
        }

        // Make Detail object from query results
        let newDetail = Detail(memoryID: memoryUUID, text: text, question: question, category: category, audio: audioURL, image: imageURL)

        return newDetail
    }
    
}
