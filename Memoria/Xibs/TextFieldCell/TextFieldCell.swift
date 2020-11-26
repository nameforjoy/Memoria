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
        
        self.textField.dynamicFont = Typography.bodyRegular
        self.textField.delegate = self
    }
    
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didFinishEditing(text: textField.text)
    }
    
    // Limit the number of characters an user can input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 50 characters
        return updatedText.count <= 50
    }
}
