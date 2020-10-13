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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrolledByKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpText()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Handle Notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Adjusts the position of the scroll view when the keyboard appears
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        let activeFieldMaxY: CGFloat = self.textAnswer.frame.maxY - self.scrollView.contentOffset.y

        // Valor máximo do Y para que não seja sobreposto pelo teclado
        let maxVisibleY = self.scrollView.frame.height - keyboardFrame.height

        // Se TextField seria coberto, scrolla o conteúdo para cima
        if activeFieldMaxY >= maxVisibleY {
            self.scrollView.contentOffset.y += maxVisibleY - keyboardFrame.height
            self.scrolledByKeyboard = true
        }
    }

    // Adjusts the position of the scroll view when the keyboard hides back to where it was
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        // If the screen was scrolled, go back to the original position
        if self.scrolledByKeyboard {
            self.scrollView.contentOffset.y -= (self.scrollView.frame.height - keyboardFrame.height) - keyboardFrame.height
        }
        // Updates flag back for non scrolled-by-keyboard position
        self.scrolledByKeyboard = false
    }
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    @IBAction func saveMemory(_ sender: Any) {
        // Save memory on database
        // Goes back to memory box screen
        let dataManager = DataManager()
        let question = self.subtitle.text ?? ""
        let text = self.textAnswer.text ?? ""
        let newMemoryDetail = Detail(text: text, question: question)
        dataManager.saveMemoryDetail(detail: newMemoryDetail)
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
    func setUpText() {
        self.subtitle.text = "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum?"
        
        // Set up dynamic font
        let font = UIFont(name: "SFProDisplay-Light", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.subtitle.dynamicFont = font
        self.saveMemoryButton.dynamicFont = font
        self.textAnswer.dynamicFont = font
        
        // Accessibility configurations
        self.changeTextForAccessibility()
    }
    
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Pergunta"
        } else {
            self.navigationItem.title = "Título da pergunta"
        }
    }
}
