//
//  QuestionViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {

    // MARK: Attributes
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var textAnswer: UITextView!
    @IBOutlet weak var saveMemoryButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var audioRecordLabel: UILabel!
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioSubtitle: UILabel!
    
    var scrollOffsetBeforeKeyboard = CGPoint()
    
    // MARK: Life cycle
    
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
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Actions
    
    /// Saves memory to database and return to main screen
    @IBAction func saveMemory(_ sender: Any) {
        performSegue(withIdentifier: "unwindSaveMemoryToCollection", sender: self)
    }
    
    // MARK: Keyboard
    
    // Adjusts the position of the scroll view when the keyboard appears
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        guard let activeInputView = self.textAnswer else {return}
        
        self.scrollOffsetBeforeKeyboard = self.scrollView.contentOffset
        self.scrollView.adjustScrollOffsetToKeyboard(keyboardFrame: keyboardFrame,
                                          inputViewFrame: activeInputView.frame)
    }

    // Adjusts the position of the scroll view when the keyboard hides back to where it was
    @objc func keyboardWillHide(notification: Notification) {
        self.scrollView.contentOffset.y = self.scrollOffsetBeforeKeyboard.y
    }
    
    // Dismisses keyboard after tapping outside keyboard
    @objc func dismissKeyboard() {
        self.textAnswer.resignFirstResponder()
    }
    
    // MARK: Segue
    
    // Passes needed information the the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set .didJustSaveMemory attribute to true so that the "save memory alert" show up as soon as the segue is performed
        if let destination = segue.destination as? MemoryCollectionViewController {
            destination.didJustSaveAMemory = true
        }
    }
    
    // MARK: Text Acessibility
    
    /// Adjustments to be made if font size is changed through the dynamic type accessibility settings
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    /// Set up question texts in its respective labels.
    func setUpText() {
        // Set up dynamic font
        let font = UIFont(name: "SFProDisplay-Light", size: 18) ?? UIFont.systemFont(ofSize: 18)
        self.subtitle.dynamicFont = font
        self.saveMemoryButton.dynamicFont = font
        self.textAnswer.dynamicFont = font
        self.audioSubtitle.dynamicFont = font
        self.audioRecordLabel.dynamicFont = font
        
        let fontBold = UIFont(name: "SFProDisplay-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24)
        self.audioTitle.dynamicFont = fontBold
        
        // Accessibility configurations
        self.changeTextForAccessibility()
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.subtitle.text = "Lorem ipsum dolor lorem ipsum?"
            self.navigationItem.title = "Pergunta"
        } else {
            self.subtitle.text = "Lorem ipsum dolor lorem ipsum dolor lorem ipsum dolor lorem ipsum lorem ipsum lorem ipsum lorem ipsum?"
            self.navigationItem.title = "Título da pergunta"
        }
    }
}
