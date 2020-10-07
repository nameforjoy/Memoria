//
//  ViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/10/20.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var loremLabel: UILabel!
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.save()
        //self.retrieve()
        self.setupAccessibility()
    }
    
    func save() {
        let title = "Olá"
        
        let record = CKRecord(recordType: "Memory")
        
        record.setValue(title, forKey: "title")
        
        self.privateDatabase.save(record) { (savedRecord, error) in
            
            if error == nil {
                
                print("Record Saved")
                
            } else {
                
                print("Record Not Saved")
                print(error)
                
            }
            
        }
    }
    
//    func retrieve() {
//        let predicate = NSPredicate(value: true)
//
//        let query = CKQuery(recordType: "Memory", predicate: predicate)
//        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
//
//        let operation = CKQueryOperation(query: query)
//
//        var titles = [String]()
//
//        operation.recordFetchedBlock = { record in
//
//            titles.append(record["title"]!)
//            print(record)
//
//        }
//
//        operation.queryCompletionBlock = { cursor, error in
//
//            DispatchQueue.main.async {
//
//                print("Titles: \(titles)")
//
//            }
//
//        }
//
//
//        privateDatabase.add(operation)
//    }
    
    
    /// Method for configuring accessibility
    /// Set font and size, then associate with the label as a dynamicFont
    private func setupAccessibility() {
        let loremFont = UIFont(name: "SFProDisplay-Black", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.loremLabel.dynamicFont = loremFont
        
        //print(UIFont.familyNames) //know if the font is intalled
    }

}
