//
//  TextViewCell.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

protocol TextViewCellDelegate: AnyObject {
    func didFinishWriting(text: String)
    func didEndEditing(text: String)
}

class TextViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    // Placeholder control
    weak var textViewCellDelegate: TextViewCellDelegate?
    var shouldDisplayPlaceholderText: Bool = true
    
    var placeholderText: String = "" {
        didSet {
            self.textView.text = self.placeholderText
            self.textView.textColor = UIColor.lightGray
        }
    }
    
    var writtenText: String = "" {
        didSet {
            if !self.writtenText.trimmingCharacters(in: .whitespaces).isEmpty {
                self.textView.text = self.writtenText
                self.textView.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up dynamic font
        let typography = Typography()
        self.textView.dynamicFont = typography.bodyRegular
        self.textView.layer.cornerRadius = 10
        
        self.textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TextViewCell: UITextViewDelegate {

    // Removes placeholder once user starts editing textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Configure text view for person to write in
        // If placeholder is displayed, erase it and change text color to black
        if self.shouldDisplayPlaceholderText {
            textView.text = nil
            textView.textColor = UIColor.black
            self.shouldDisplayPlaceholderText = false
        }
    }

    // Display placeholder if user left texview empty
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewCellDelegate?.didFinishWriting(text: textView.text)
    }

    // Updates text at any time text changes
    func textViewDidChange(_ textView: UITextView) {
        self.textViewCellDelegate?.didEndEditing(text: textView.text)
    }
    
    // Limit the number of characters an user can input
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 2000 characters
        return updatedText.count <= 2000
    }
}
