//
//  MediaManager.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 23/10/20.
//

import UIKit
import CloudKit

class MediaManager {
    static func getImageAsset(image: UIImage) -> CKAsset? {
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
    
    static func getURL(image: UIImage) -> URL? {
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
    
    static func getUIImage(imageURL: URL) -> UIImage? {
        if let data = try? Data(contentsOf: (imageURL)),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    static func getUIImage(imageAsset: CKAsset) -> UIImage? {
        if let url = imageAsset.fileURL,
           let data = try? Data(contentsOf: (url)),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}
