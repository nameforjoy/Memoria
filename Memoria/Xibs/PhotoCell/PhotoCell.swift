//
//  PhotoCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var imageCellView: UIImageView!
    var imageSelected: UIImage? {
        didSet {
            self.imageCellView?.image = imageSelected
            if let image = self.imageSelected {
                let screenSize: CGRect = UIScreen.main.bounds
                self.imageCellView.frame = CGRect(x: 0, y: 0, width: self.imageCellView.frame.size.width, height: ajustImageHeight(image: image))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageCellView?.image = imageSelected
        self.imageCellView.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func ajustImageHeight(image: UIImage) -> CGFloat {
        let newHeight = imageCellView.frame.width / ( image.size.width / image.size.height)
        return newHeight
    }
}
