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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageSelected = UIImage(named: "photo2")
        self.imageCellView.contentMode = .scaleAspectFill
        self.imageCellView?.image = self.imageSelected
        self.imageCellView.layer.cornerRadius = 20
        self.imageCellView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
