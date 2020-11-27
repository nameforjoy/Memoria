//
//  TitleSubtitleCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

enum RemoveType {
    case removeImage
    case removeAudio
    case undefined
}

protocol TitleSubtitleCellDelegate: AnyObject {
    func didTapRemove(buttonType: RemoveType)
}

class TitleSubtitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var removeButtonIsHidden: Bool = true {
        didSet {
            if removeButtonIsHidden {
                hideButton()
            } else {
                showButton()
            }
        }
    }
    
    var isAccessibilityCategory: Bool = false {
        didSet {
            self.setUpButtonAppearance()
        }
    }
    
    var removeType: RemoveType = .undefined
    weak var removeButtonDelegate: TitleSubtitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpText()
        hideButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        // Set up dynamic font
        self.titleLabel.dynamicFont = Typography.title2Bold
        self.subtitleLabel.dynamicFont = Typography.bodyRegular
        self.removeButton.dynamicFont = Typography.calloutSemibold
    }
    
    func hideButton() {
        self.removeButton.setTitle("", for: .normal)
        self.removeButton.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func showButton() {
        self.setUpButtonAppearance()
        self.removeButton.isHidden = false
        self.isUserInteractionEnabled = true
    }
    
    func setUpButtonAppearance() {
        if self.isAccessibilityCategory {
            self.removeButton.setTitle("", for: .normal)
            self.removeButton.setBackgroundImage(UIImage(named: "trash"), for: .normal)
            // self.tintColor = UIColor(named: "coral")
        } else {
            self.removeButton.setTitle("Remover", for: .normal)
        }
    }

    @IBAction func removeAction(_ sender: Any) {
        self.removeButtonDelegate?.didTapRemove(buttonType: self.removeType)
    }
}
