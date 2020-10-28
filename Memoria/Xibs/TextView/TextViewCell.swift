//
//  TextViewCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        self.textView.text = "Descreva sua memória aqui..."
        // Set up dynamic font
        let typography = Typography()
        self.textView.dynamicFont = typography.bodyRegular
        self.textView.textColor = UIColor.lightGray
    }

}
