//
//  IconButton.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 26/10/20.
//

import UIKit

protocol IconTextButtonDelegate: AnyObject {
    func iconTextButtonAction()
}

@IBDesignable class IconButtonView: UIView {
    
    // MARK: Attributes
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    weak var delegate: IconTextButtonDelegate?
    
    // MARK: Initializers
    
    // This constructor/initializer will be called when you are creating PersonView programmatically with init(frame: CGRect)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xibSetUp()
        self.visualSetUp()
    }
    
    // Whenever contents of a nib file are unarchived, system calls this initializer.
    required init?(coder aDrecoder: NSCoder) {
        super.init(coder: aDrecoder)
        
        self.xibSetUp()
        self.visualSetUp()
    }
    
    // MARK: Action
    
    @IBAction func iconTextButtonAction(_ sender: Any) {
        self.delegate?.iconTextButtonAction()
    }
    
    // MARK: Set up
    
    private func xibSetUp() {
        Bundle.main.loadNibNamed("IconButton", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func visualSetUp() {
        self.backgroundView.layer.cornerRadius = self.backgroundView.frame.height/6
        self.title.dynamicFont = Typography().calloutSemibold
    }
}
