//
//  Slide.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 25/11/20.
//

import UIKit

protocol SlideDelegate: AnyObject {
    func didPressStartButton()
}

class Slide: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: GradientButtonView!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var slideDelegate: SlideDelegate?
    
    var configButtonIsHidden: Bool = true {
        didSet {
            if self.configButtonIsHidden {
                self.configButton.isHidden = true
            } else {
                self.configButton.isHidden = false
            }
        }
    }
    
    let purple: UIColor = UIColor(named: "purple") ?? UIColor.purple

    func setupSlide1() {
        self.label.dynamicFont = Typography.largeTitleBold
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Boas vindas à \nRememoria!")
        attributedString.setColorForText(textForAttribute: "Rememoria", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.button.isHidden = true
        self.configButtonIsHidden = true
    }
    
    func setupSlide2() {
        self.label.dynamicFont = Typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Verifique se possui espaço livre de armazenamento no iCloud pois é lá que guardaremos suas memórias para sua segurança!")
        attributedString.setColorForText(textForAttribute: "armazenamento no iCloud", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.configButtonIsHidden = false
        self.button.isHidden = true
        self.configButton.dynamicFont = Typography.calloutSemibold
    }
    
    func setupSlide3() {
        self.label.dynamicFont = Typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Para registrar, você pode escolher texto, áudio ou foto, ou até os três! Vamos te conduzir num fluxo de perguntas para que suas memórias fiquem ainda mais vivas.")
        attributedString.setColorForText(textForAttribute: "escolher texto, áudio ou foto", withColor: purple)
        attributedString.setColorForText(textForAttribute: "fluxo de perguntas", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.button.isHidden = true
        self.configButtonIsHidden = true
    }
    
    func setupSlide4() {
        self.label.dynamicFont = Typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Aproveite o momento de reconstruir suas lembranças e ressignificá-las. Respire fundo e explore mais sobre você. Vamos lá?")
        attributedString.setColorForText(textForAttribute: "Vamos lá?", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.button.delegate = self
        self.button.isEnabled = true
        self.button.isHidden = false
        self.configButtonIsHidden = true
    }
    
    @IBAction func goToConfig(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}

extension Slide: GradientButtonDelegate {
    func gradientButtonAction() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "onboardingSeen")
        if let delegate: SlideDelegate = self.slideDelegate {
            delegate.didPressStartButton()
        }
    }
}
