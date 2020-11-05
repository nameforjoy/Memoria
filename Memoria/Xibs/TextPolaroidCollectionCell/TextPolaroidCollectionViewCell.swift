//
//  TextPolaroidCollectionViewCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/11/20.
//

import UIKit

class TextPolaroidCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let identifier = "TextPolaroidCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(titleText: String, timeText: String) {
        self.titleLabel.text = titleText
        self.timeLabel.text = timeText
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TextPolaroidCollectionViewCell", bundle: nil)
    }

}
