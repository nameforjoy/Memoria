//
//  QuestionViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var textAnswer: UITextView!
    @IBOutlet weak var saveMemoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpQuestion()
        self.setUpDynamicType()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func saveMemory(_ sender: Any) {
        // Save memory on database
        // Goes back to memory box screen
        performSegue(withIdentifier: "unwindSaveMemoryToCollection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MemoryCollectionViewController {
            destination.didJustSaveAMemory = true
        }
    }
    
    /// Dismisses keyboard after tapping outside keyboard
    @objc func dismissKeyboard() {
        self.textAnswer.resignFirstResponder()
    }
    
    /// Puts question texts in its respective labels
    func setUpQuestion() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Pergunta"
        } else {
            self.navigationItem.title = "Título da pergunta"
        }
        self.subtitle.text = "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum?"
    }
    
    /// Method for configuring dynamic type accessibility.
    /// Sets font and size, then associates it with the label as a dynamicFont
    func setUpDynamicType() {
        
        let font = UIFont(name: "SFProDisplay-Light", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.subtitle.dynamicFont = font
        
        // NÃO FUNCIONA
        self.textAnswer.font = font
    }
}
