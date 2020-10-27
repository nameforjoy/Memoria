//
//  GradientButton.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 26/10/20.
//

import UIKit

protocol GradientButtonDelegate: AnyObject {
    func gradientButtonAction()
}

@IBDesignable class GradientButtonView: UIView {
    
    // MARK: Atributes
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gradientButton: UIButton!
    
    weak var delegate: GradientButtonDelegate?
    
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
    
    @IBAction func gradientButtonAction(_ sender: Any) {
        self.delegate?.gradientButtonAction()
    }
    
    // MARK: Set up
    
    private func xibSetUp() {
        Bundle.main.loadNibNamed("GradientButton", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func visualSetUp() {
        self.gradientButton.layer.cornerRadius = self.gradientButton.frame.height/3
        self.gradientButton.applyGradient(colors: [UIColor(hexString: "75679E").cgColor, UIColor(hexString: "A189E2").cgColor])
        self.gradientButton.dynamicFont = Typography().calloutSemibold
    }
}
