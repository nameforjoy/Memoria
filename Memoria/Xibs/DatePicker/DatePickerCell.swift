//
//  DatePickerCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 29/10/20.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    var timeUnit: Calendar.Component?
    var timePassedBy: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.keyboardType = UIKeyboardType.decimalPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

        
    @IBAction func rangeSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.timeUnit = .day
        case 1:
            self.timeUnit = .month
        case 2:
            self.timeUnit = .year
        default:
            self.timeUnit = .day
        }
    }
}

extension DatePickerCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let timeInt = Int(text) {
            self.timePassedBy = timeInt
        }
        //chamar delegate
    }
}
