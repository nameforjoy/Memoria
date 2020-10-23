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
//        getImageFromBD(completion: { asset in
//            let uiImage = self.getUIImage(imageAsset: asset[0])
//            self.imageView.image = uiImage
//        })
    }
        
    func getUIImage(imageAsset: CKAsset) -> UIImage? {
        if let url = imageAsset.fileURL,
           let data = try? Data(contentsOf: (url)),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func getUIImage(imageURL: URL) -> UIImage? {
        if let data = try? Data(contentsOf: (imageURL)),
           let image = UIImage(data: data) {
            return image
        }
        return nil
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
    
    func getUIImageURL(image: UIImage) -> URL? {
        let data = image.pngData()
        if let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat") {
            do {
                try data?.write(to: url)
            } catch let err as NSError {
                print("Error! \(err)")
            }
            return url
        }
        return nil
    }
    
}

extension ImageSelectionViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
//        self.saveImageBD()
    }
}
