//
//  GradientViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 25/11/20.
//

import UIKit

class GradientViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(hexString: "58BFE0").cgColor // blue
    let gradientTwo = UIColor(hexString: "8571BE").cgColor // purple
    let gradientThree = UIColor(hexString: "5C5081").cgColor // dark purple
    
    let interval = TimeInterval(3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.gradientView.layer.addSublayer(gradient)
        
        self.configureText()
        self.animateGradient()
    }
    
    func configureText() {
        self.textLabel.dynamicFont = Typography.title2Bold
        self.textLabel.text = "Pense na memória que escolheu..."
        
        Timer.scheduledTimer(timeInterval: self.interval, target: self, selector: #selector(changeFirstText), userInfo: nil, repeats: false)
    }
    
    @objc func changeFirstText() {
        self.textLabel.fadeTransition(0.7)
        self.textLabel.text = "Respire fundo..."
        
        Timer.scheduledTimer(timeInterval: self.interval, target: self, selector: #selector(changeSecondText), userInfo: nil, repeats: false)
    }
    
    @objc func changeSecondText() {
        self.textLabel.fadeTransition(0.7)
        self.textLabel.text = "Vamos começar..."
        
        Timer.scheduledTimer(timeInterval: self.interval, target: self, selector: #selector(startImmersion), userInfo: nil, repeats: false)
    }
    
    @objc func startImmersion() {
        // Segue
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        self.gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
}

extension GradientViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            self.animateGradient()
        }
    }
}
