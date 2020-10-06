//
//  ViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loremLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupAccessibility()
    }
    
    private func setupAccessibility() {
        let loremFont = UIFont(name: "SFProDisplay-Black", size: 18) ?? UIFont.systemFont(ofSize: 18)

        self.loremLabel.dynamicFont = loremFont
        print(UIFont.familyNames)
    }

}
