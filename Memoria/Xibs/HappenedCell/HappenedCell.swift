//
//  HappenedCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 30/10/20.
//

import UIKit

class HappenedCell: UITableViewCell {

    @IBOutlet weak var happenedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
        let typography = Typography()
        self.happenedLabel.dynamicFont = typography.bodyRegular
        self.timeLabel.dynamicFont = typography.bodySemibold
    }
    
    @objc func tappedCell() {
        
    }
}
