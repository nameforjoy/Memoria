//
//  MemoryBoxTableViewCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/11/20.
//

import UIKit

class MemoryBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupFont()
    }
    
    func setupView() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.systemGray6.cgColor
        
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor(hexString: "8A77BF").cgColor
    }
    
    func setupFont() {
        self.titleLabel.dynamicFont = Typography.title2Bold
        self.timeLabel.dynamicFont = Typography.bodyRegular
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
