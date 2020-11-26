//
//  IconButtonCell.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 27/10/20.
//

import UIKit

enum ButtonType {
    case addImage
    case addAudio
    case undefined
}

protocol IconButtonCellDelegate: AnyObject {
    func iconButtonCellAction(buttonType: ButtonType, sender: Any)
}

class IconButtonCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var background: UIView!
    
    weak var buttonDelegate: IconButtonCellDelegate?
    var buttonType: ButtonType = .undefined
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.background.layer.cornerRadius = 10
        self.title.dynamicFont = Typography.calloutSemibold
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func iconButtonAction(_ sender: Any) {
        self.buttonDelegate?.iconButtonCellAction(buttonType: self.buttonType, sender: sender)
    }
}
