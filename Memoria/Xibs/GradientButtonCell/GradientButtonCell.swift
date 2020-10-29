//
//  GradientButtonCell.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 29/10/20.
//

import UIKit

protocol GradientButtonCellDelegate: AnyObject {
    func gradientButtonCellAction()
}

class GradientButtonCell: UITableViewCell {

    @IBOutlet weak var gradientButton: UIButton!
    
    weak var buttonDelegate: GradientButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up button visual
        self.gradientButton.layer.cornerRadius = self.gradientButton.frame.height/3
        self.gradientButton.applyGradient(colors: [UIColor(hexString: "75679E").cgColor, UIColor(hexString: "A189E2").cgColor])
        self.gradientButton.dynamicFont = Typography().calloutSemibold
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func gradientButtonAction(_ sender: Any) {
        self.buttonDelegate?.gradientButtonCellAction()
    }
    
}
