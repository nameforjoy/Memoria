//
//  IconButton.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 26/10/20.
//

import UIKit

protocol IconButtonDelegate: AnyObject {
    func iconButtonAction()
}

class IconButtonView: UIView {
    
    // MARK: Attributes
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    weak var buttonDelegate: IconButtonDelegate?
    
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
    
    @IBAction func iconButtonAction(_ sender: Any) {
        self.buttonDelegate?.iconButtonAction()
    }
    
    // MARK: Set up
    
    private func xibSetUp() {
        Bundle.main.loadNibNamed("IconButton", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func visualSetUp() {
        self.background.layer.cornerRadius = 10
        self.title.dynamicFont = Typography.calloutSemibold
    }
}
