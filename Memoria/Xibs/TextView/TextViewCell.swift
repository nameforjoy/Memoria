//
//  TextViewCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    // Placeholder control
    var shouldDisplayPlaceholderText: Bool = true
    var placeholderText: String = "" {
        didSet {
            self.textView.text = placeholderText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpText()
        self.textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpText() {
        self.textView.text = placeholderText
        
        // Set up dynamic font
        let typography = Typography()
        self.textView.dynamicFont = typography.bodyRegular
        self.textView.textColor = UIColor.lightGray
    }

}

extension TextViewCell: UITextViewDelegate {

    // Removes placeholder once user starts editing textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            self.shouldDisplayPlaceholderText = false
        }
    }

    // Display placeholder if user left texview empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
            self.shouldDisplayPlaceholderText = true
        }
    }
}
