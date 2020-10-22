//
//  ImageSelectionViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 21/10/20.
//

import UIKit
import CloudKit

class ImageSelectionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func pickImageClick( sender: Any) {
        guard let senderView = sender as? UIView else { return }
        self.imagePicker.present(from: senderView)
    }
    
    func saveImageBD() {
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let record = CKRecord(recordType: "Detail")
        
        let image = getImageAsset(image: self.imageView.image!)

        record.setValue(image, forKey: "image")
        
        privateDatabase.save(record) { (savedRecord, error) in

            if error == nil {
                print("Record Saved")
                print(savedRecord?.object(forKey: "image") ?? "Nil")

            } else {
                print("Record Not Saved")
                print(error ?? "Nil")
                
            }
        }
    }
    
    func getImageAsset(image: UIImage) -> CKAsset? {
        let data = image.pngData()
        if let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") {
            do {
                try data?.write(to: url)
            } catch let err as NSError {
                print("Error! \(err)")
            }
            return CKAsset(fileURL: url)
        }
        return nil
    }
    
}

extension ImageSelectionViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
        self.saveImageBD()
    }
}
