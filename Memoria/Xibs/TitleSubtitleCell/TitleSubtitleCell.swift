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
                setUpHiddenButton()
            } else {
                setUpButton()
            }
        }
    }
    var removeType: RemoveType = .undefined
    weak var removeButtonDelegate: TitleSubtitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpText()
        setUpHiddenButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        // Set up dynamic font
        let typography = Typography()
        self.titleLabel.dynamicFont = typography.title2Bold
        self.subtitleLabel.dynamicFont = typography.bodyRegular
        self.removeButton.dynamicFont = typography.calloutSemibold
    }
    
    func setUpHiddenButton() {
        self.removeButton.setTitle("", for: .normal)
        self.removeButton.isHidden = true
        self.isUserInteractionEnabled = false
    }
    
    func setUpButton() {
        self.removeButton.setTitle("Remover", for: .normal)
        self.removeButton.isHidden = false
        self.isUserInteractionEnabled = true
    }

    @IBAction func removeAction(_ sender: Any) {
        self.removeButtonDelegate?.didTapRemove(buttonType: self.removeType)
    }
}
