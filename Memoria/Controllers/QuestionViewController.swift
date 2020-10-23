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
    @IBOutlet weak var audioButtonBackground: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var audioContent: URL?
    var imageURL: URL?
    var scrollOffsetBeforeKeyboard = CGPoint()
    var imagePicker: ImagePicker!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Configures buttons
        self.saveMemoryButton.layer.cornerRadius = self.saveMemoryButton.frame.height/4
        self.saveMemoryButton.applyGradient(colors: [UIColor(hexString: "75679E").cgColor, UIColor(hexString: "A189E2").cgColor])
        self.saveMemoryButton.clipsToBounds = true
        self.audioButtonBackground.layer.cornerRadius = self.audioButtonBackground.frame.height/6
        
        // Handle Notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Initialize ImagePicker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpText()
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func recordAudio(_ sender: Any) {
        guard let recordAudioScreen = (self.storyboard?.instantiateViewController(identifier: "inputAudioVC")) as? InputAudioVC else {return}

        // Ties up this class as delegate for InputAudioVC
        recordAudioScreen.audioDelegate = self

        self.presentAsModal(show: recordAudioScreen, over: self)
    }

    /// Saves memory to database and return to main screen
    @IBAction func saveMemory(_ sender: Any) {
        // Organize content given by user
        let question = self.subtitle.text ?? ""
        let text = self.textAnswer.text ?? ""
        let audio = self.audioContent
        let image = self.imageURL

        // TODO: Puxar imagem da ImageSelectionViewController
        // let image: CKAsset? = nil

        // Creates detail object
        let newMemoryDetail = Detail(text: text, question: question, audio: audio, image: image)

        // Calls DAO to object to database
        DetailDAO.create(detail: newMemoryDetail)

        // Return to main screen
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
    
    // MARK: Acessibility
    
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
        
        // Set text that will not change with accessibility
        self.writeFixedText()
    }
    
    func writeFixedText() {
        self.subtitle.text = "O que aconteceu ou está acontecendo? Como você gostaria de se lembrar disso?"
        self.textAnswer.text = "Descreva sua memória aqui..."
        self.audioTitle.text = "Que tal gravar?"
        self.audioSubtitle.text = "Você pode contar em áudio ou gravar algo que queira se lembrar futuramente!"
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Me conta"
        } else {
            self.navigationItem.title = "Conta pra mim!"
        }
    }
}

// MARK: Audio Recorder

extension QuestionViewController: AudioRecordingDelegate {
    
    /// Delegate method to populate audio data
    func finishedRecording(audioURL: URL) {
        // This content will be used on saveMemory()
        self.audioContent = audioURL
    }
    
    func presentAsModal(show viewController: UIViewController, over context: UIViewController) {
        
        // Set up presentation mode
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Set up background to mimic the iOS native Alert
        viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Present alert
        context.present(viewController, animated: true, completion: nil)
    }
}

///Extension For ImagePicker
extension QuestionViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let contentImage = image {
            self.imageView.contentMode = .scaleToFill
            self.imageView.frame.size.height = ajustImageHeight(image: contentImage)
            self.imageView.image = contentImage
            self.imageURL = MediaManager.getURL(image: contentImage)
        }
    }
    
    func ajustImageHeight(image: UIImage) -> CGFloat {
        let newHeight = imageView.frame.width / ( image.size.width / image.size.height)
        return newHeight
    }
}
