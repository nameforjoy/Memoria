//
//  TextFieldCell.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.dynamicFont = Typography().bodyRegular
        self.textField.layer.borderWidth = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
