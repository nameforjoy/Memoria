//
//  ImageSelectionViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 21/10/20.
//

import UIKit

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
}

extension ImageSelectionViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}
