//
//  DatePickerCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 29/10/20.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func didChangeDate(timePassed: Int, component: Calendar.Component)
}

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    var timeUnit: Calendar.Component = .day
    var timePassed: Int = 0
    
    weak var dateDelegate: DatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.keyboardType = UIKeyboardType.numberPad
        self.textField.dynamicFont = Typography().bodySemibold
        self.textField.delegate = self
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
        self.dateDelegate?.didChangeDate(timePassed: self.timePassed, component: self.timeUnit)
    }
}

extension DatePickerCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.timePassed = Int(textField.text ?? "0") ?? 0
        self.dateDelegate?.didChangeDate(timePassed: self.timePassed, component: self.timeUnit)
    }
}
