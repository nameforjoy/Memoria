//
//  HappenedCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 30/10/20.
//

import UIKit

protocol ExpandableCellDelegate: AnyObject {
    func expandCells()
    func hideCells()
}

class ExpandingCell: UITableViewCell {

    @IBOutlet weak var happenedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    weak var expansionDelegate: ExpandableCellDelegate?
    var isRotated: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedCell))
        self.contentView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpText() {
        // Set up dynamic font
        self.happenedLabel.dynamicFont = Typography.bodyRegular
        self.timeLabel.dynamicFont = Typography.bodySemibold
    }
    
    @objc func tappedCell() {
        if self.isRotated {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
            self.expansionDelegate?.hideCells()
        } else {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.expansionDelegate?.expandCells()
        }
        self.isRotated = !self.isRotated
    }
}
