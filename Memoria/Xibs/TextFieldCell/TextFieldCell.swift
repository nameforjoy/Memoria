//
//  TextFieldCell.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func didFinishEditing(text: String?)
}

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.dynamicFont = Typography().bodyRegular
        self.textField.delegate = self
    }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didFinishEditing(text: textField.text)
    }
}
