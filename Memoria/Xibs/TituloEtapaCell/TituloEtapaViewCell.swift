//
//  TituloEtapaViewCell.swift
//  AppUser
//
//  Created by Luma Gabino Vasconcelos on 24/04/20.
//  Copyright © 2020 Gabriel Ferreira. All rights reserved.
//

import UIKit

protocol TitleStageCellDelegate {
    func didTapEditCell(_ cell: TituloEtapaViewCell)
    func didTapDeleteCell(_ cell: TituloEtapaViewCell)
}

class TituloEtapaViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: TitleStageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAccessibility()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupAccessibility() {
        let titleFont = UIFont(name: "SFProDisplay-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)

        self.titleLabel.dynamicFont = titleFont
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
    @IBAction func editTitle(_ sender: Any) {
        delegate?.didTapEditCell(self)

    }
    @IBAction func deleteStage(_ sender: Any) {
        delegate?.didTapDeleteCell(self)
    }
}
