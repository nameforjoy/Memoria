//
//  DontRemeberCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 30/10/20.
//

import UIKit

class DontRemeberCell: UITableViewCell {
    
    @IBOutlet weak var dontRemeberLabel: UILabel!
    @IBOutlet weak var switchSelector: UISwitch!

    var hasDate: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.switchSelector.isOn = false
        self.setUpText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        // Set up dynamic font
        let typography = Typography()
        self.dontRemeberLabel.dynamicFont = typography.bodyRegular
    }
    
    @IBAction func dontRemberSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.hasDate = false
        } else {
            self.hasDate = true
        }
    }
}
