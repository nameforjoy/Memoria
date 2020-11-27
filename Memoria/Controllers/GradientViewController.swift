//
//  GradientViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 25/11/20.
//

import UIKit

class GradientViewController: UIViewController {
    
    // MARK: Attributes
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradientIndex: Int = 0
    
    let color1 = UIColor(hexString: "58BFE0").cgColor // blue
    let color2 = UIColor(hexString: "8571BE").cgColor // purple
    let color3 = UIColor(hexString: "5C5081").cgColor // dark purple
    
    let textTransitionInterval = TimeInterval(4) // in seconds
    var didSkipIntro: Bool = false
    var memoryID: UUID?
    
    //  MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.dynamicFont = Typography.title2Bold
        
        // Add skip button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pular", style: .plain, target: self, action: #selector(skipIntro))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureGradient()
        self.didSkipIntro = false
        self.textLabel.text = "Pense em uma memória..."
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start gradient and text animations
        self.animateGradient()
        Timer.scheduledTimer(timeInterval: self.textTransitionInterval, target: self, selector: #selector(changeFirstText), userInfo: nil, repeats: false)
    }
    
    // MARK: Text
    
    @objc func changeFirstText() {
        self.textLabel.fadeTransition(1.0)
        self.textLabel.text = "Respire fundo..."
        
        if !didSkipIntro {
            Timer.scheduledTimer(timeInterval: self.textTransitionInterval, target: self, selector: #selector(changeSecondText), userInfo: nil, repeats: false)
        }
    }
    
    @objc func changeSecondText() {
        self.textLabel.fadeTransition(1.0)
        self.textLabel.text = "Vamos começar..."
        
        if !didSkipIntro {
            Timer.scheduledTimer(timeInterval: self.textTransitionInterval, target: self, selector: #selector(startImmersion), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: Segue
    
    @objc func skipIntro() {
        self.didSkipIntro = true
        performSegue(withIdentifier: "startImmersion", sender: self)
    }
    
    @objc func startImmersion() {
        if !self.didSkipIntro {
            performSegue(withIdentifier: "startImmersion", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QuestionTableViewController {
            // Set ID for new memory being created
            destination.memoryID = UUID()
        }
    }
    
    // MARK: Gradient animation
    
    func configureGradient() {
        self.gradientSet.append([self.color1, self.color2])
        self.gradientSet.append([self.color2, self.color3])
        self.gradientSet.append([self.color3, self.color1])
        
        self.gradientLayer.frame = self.gradientView.bounds
        self.gradientLayer.colors = self.gradientSet[self.currentGradientIndex]
        self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.gradientLayer.drawsAsynchronously = true
        self.gradientView.layer.addSublayer(self.gradientLayer)
    }
    
    func animateGradient() {
        // Update index
        if self.currentGradientIndex < self.gradientSet.count - 1 {
            self.currentGradientIndex += 1
        } else {
            self.currentGradientIndex = 0
        }
        // Configure animation
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 3.0
        gradientChangeAnimation.toValue = self.gradientSet[self.currentGradientIndex]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        self.gradientLayer.add(gradientChangeAnimation, forKey: "colorChange")
    }
}

extension GradientViewController: CAAnimationDelegate {
    
    // Make animation continue (start over)
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.gradientLayer.colors = self.gradientSet[self.currentGradientIndex]
            self.animateGradient()
        }
    }
}
