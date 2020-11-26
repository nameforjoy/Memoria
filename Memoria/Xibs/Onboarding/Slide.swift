//
//  Slide.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 25/11/20.
//

import UIKit

protocol SlideDelegate {
    func didPressStartButton()
}

class Slide: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: GradientButtonView!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var slideDelegate: SlideDelegate? = nil
    
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
        let typography = Typography()
        self.label.dynamicFont = typography.largeTitleBold
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Bem-vinde à \nRememoria!")
        attributedString.setColorForText(textForAttribute: "Rememoria", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.configButtonIsHidden = true
    }
    
    func setupSlide2() {
        let typography = Typography()
        self.label.dynamicFont = typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Verifique se possui espaço livre de armazenamento no iCloud pois é lá que guardaremos suas memórias para sua segurança!")
        attributedString.setColorForText(textForAttribute: "armazenamento no iCloud", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.configButtonIsHidden = false
        self.configButton.dynamicFont = typography.calloutSemibold
    }
    
    func setupSlide3() {
        let typography = Typography()
        self.label.dynamicFont = typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Para registrar, você pode escolher texto, áudio ou foto, ou até os três! Vamos te conduzir num fluxo de perguntas para que suas memórias fiquem ainda mais vivas.")
        attributedString.setColorForText(textForAttribute: "escolher texto, áudio ou foto", withColor: purple)
        attributedString.setColorForText(textForAttribute: "fluxo de perguntas", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.configButtonIsHidden = true
    }
    
    func setupSlide4() {
        let typography = Typography()
        self.label.dynamicFont = typography.bodyRegular
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Aproveite o momento de reconstruir suas lembranças e ressignificá-las. Respire fundo e explore mais sobre você. Vamos lá?")
        attributedString.setColorForText(textForAttribute: "Vamos lá?", withColor: purple)
        self.label.attributedText = attributedString
        
        self.button.title = "Começar"
        self.button.delegate = self
        self.button.isEnabled = true
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
