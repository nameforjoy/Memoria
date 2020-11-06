//
//  DontRemeberCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 30/10/20.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func switchIsOn()
    func switchIsOff()
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var dontRemeberLabel: UILabel!
    @IBOutlet weak var switchSelector: UISwitch!

    weak var switchDelegate: SwitchCellDelegate?
    var isSwitchOn: Bool = false {
        didSet {
            self.switchSelector.isOn = self.isSwitchOn
        }
    }
    
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
            self.switchDelegate?.switchIsOn()
        } else {
            self.switchDelegate?.switchIsOff()
        }
    }
}
