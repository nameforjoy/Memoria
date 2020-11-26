//
//  GradientButtonCell.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 29/10/20.
//

import UIKit

protocol GradientButtonCellDelegate: AnyObject {
    func gradientButtonCellAction()
    func disabledButtonAction()
}

class GradientButtonCell: UITableViewCell {

    @IBOutlet weak var gradientButton: UIButton!
    @IBOutlet weak var disabledButton: UIButton!
    
    var isEnabled: Bool = true {
        didSet {
            if self.isEnabled {
                self.disabledButton.isHidden = true
            } else {
                self.disabledButton.isHidden = false
            }
        }
    }
    
    var title: String = "Title" {
        didSet {
            self.gradientButton.setTitle(title, for: .normal)
            self.disabledButton.setTitle(title, for: .normal)
        }
    }
    
    weak var buttonDelegate: GradientButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius = self.gradientButton.frame.height/3
        self.gradientButton.layer.cornerRadius = cornerRadius
        self.disabledButton.layer.cornerRadius = cornerRadius
        
        self.gradientButton.applyGradient(colors: [UIColor(hexString: "75679E").cgColor, UIColor(hexString: "A189E2").cgColor])
        
        let titleFont = Typography.calloutSemibold
        self.gradientButton.dynamicFont = titleFont
        self.disabledButton.dynamicFont = titleFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func gradientButtonAction(_ sender: Any) {
        self.buttonDelegate?.gradientButtonCellAction()
    }
    
    @IBAction func disabledButtonAction(_ sender: Any) {
        self.buttonDelegate?.disabledButtonAction()
    }
}
