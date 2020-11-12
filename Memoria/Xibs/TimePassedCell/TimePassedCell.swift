//
//  SubtilteCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class TimePassedCell: UITableViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        // Set up dynamic font
        let typography = Typography()
        self.subtitleLabel.dynamicFont = typography.title2Regular
        self.subtitleLabel.textColor = UIColor(hexString: "828282")
    }

}
