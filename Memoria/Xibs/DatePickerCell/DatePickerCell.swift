//
//  DatePickerCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 29/10/20.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func didChangeDate(dateString: String)
}

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    var timeUnit: Calendar.Component = .day
    var timeUnitSingular: String = "dia"
    var timeUnitPlural: String = "dias"
    
    var timePassed: Int = 0
    weak var dateDelegate: DatePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.keyboardType = UIKeyboardType.decimalPad
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
            self.timeUnitSingular = "dia"
            self.timeUnitPlural = "dias"
        case 1:
            self.timeUnit = .month
            self.timeUnitSingular = "mês"
            self.timeUnitPlural = "meses"
        case 2:
            self.timeUnit = .year
            self.timeUnitSingular = "ano"
            self.timeUnitPlural = "anos"
        default:
            self.timeUnit = .day
            self.timeUnitSingular = "dia"
            self.timeUnitPlural = "dias"
        }
        let dateString = self.makeTimeString()
        self.dateDelegate?.didChangeDate(dateString: dateString)
    }
    
    func makeTimeString() -> String {
        
        var timestring = ""
        if self.timePassed == 0 {
            timestring = "Hoje"
        } else {
            timestring = "Há \(self.timePassed) " // Obs: this method must change in English to " X years ago"
            if self.timePassed <= 1 {
                timestring += self.timeUnitSingular
            } else {
                timestring += self.timeUnitPlural
            }
        }
        return timestring
    }
}

extension DatePickerCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.timePassed = Int(textField.text ?? "0") ?? 0
        let dateString = self.makeTimeString()
        self.dateDelegate?.didChangeDate(dateString: dateString)
    }
}
