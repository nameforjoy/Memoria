//
//  QuestionTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 28/10/20.
//

import UIKit
import AVFoundation
import Network

class QuestionTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    // Network monitoring
    let monitor = NWPathMonitor()
    var savingAttempts: Int = 0
    
    // Image
    var imageURL: URL?
    var imagePicker: ImagePicker?
    var selectedImage: UIImage?
    
    // Audio
    var audioURL: URL?
    
    // Text input
    var writtenText: String?
    var question: String? = ""
    
    // Associated memory ID
    var memoryID: UUID?
    
    // Interface
    var hiddenRows: [Int] = [4,7]
    var hasClickedOnSaveButton: Bool = false
    var texts = QuestionTexts()

    // Flow
    var isLastQuestion: Bool = true
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Skip Question
        if !self.isLastQuestion {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pular", style: .plain, target: self, action: #selector(skipQuestion))
        }
        
        // Table view setup
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
        
        // Text setup
        self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
        self.question = self.texts.question
        self.navigationItem.title = self.texts.category
        
        // Register xibs to be displayed in this table view
        self.registerNibs()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Observers for changes in font size
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        // Image Picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // Check internet connectivity
        self.checkInternetConnectivity(monitor: self.monitor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: "7765A8")
        
        if self.memoryID == nil {
            print("Could not find ID for this memory")
        } else {
            print(self.memoryID ?? "ID returned nil")
        }
    }
    
    deinit {
        // Remove font size change observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // MARK: Responders
    
    /// Adjustments to be made if font size is changed through the dynamic type accessibility settings
    @objc func fontSizeChanged(_ notification: Notification) {
        if self.texts.isAccessibleCategory != self.traitCollection.isAccessibleCategory {
            // Tell text class accessibility trait has changed
            self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
            // Change texts
            self.navigationItem.title = self.texts.category
            self.question = self.texts.question
            self.tableView.reloadData() // refresh table view so texts inside are also updated
        }
    }
    
    /// Dismisses keyboard after tapping outside of it
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Instantiate Nibs
    
    /// Register xibs in this table view
    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .titleSubtitleCell)
        self.tableView.registerNib(nibIdentifier: .textViewCell)
        self.tableView.registerNib(nibIdentifier: .subtitleCell)
        self.tableView.registerNib(nibIdentifier: .photoCell)
        self.tableView.registerNib(nibIdentifier: .iconButtonCell)
        self.tableView.registerNib(nibIdentifier: .audioPlayerCell)
        self.tableView.registerNib(nibIdentifier: .gradientButtonCell)
    }

    // MARK: Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Hide cells with indexes contained in the hiddenRows array
        if self.hiddenRows.contains(indexPath.row) {
            return 0.0  // collapsed
        }
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let questionCell = cell as? SubtitleCell {
                questionCell.subtitleLabel.text = self.question
                cell = questionCell
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textViewCell.rawValue, for: indexPath)
            if let textAnswerCell = cell as? TextViewCell {
                self.setUpTextAnswerCell(textAnswerCell)
                cell = textAnswerCell
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let audioTitleSubtitleCell = cell as? TitleSubtitleCell {
                audioTitleSubtitleCell.titleLabel.text = self.texts.recordAudioTitle
                audioTitleSubtitleCell.subtitleLabel.text = self.texts.recordAudioSubtitle
                audioTitleSubtitleCell.removeButtonDelegate = self
                audioTitleSubtitleCell.removeType = .removeAudio
                cell = audioTitleSubtitleCell
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.iconButtonCell.rawValue, for: indexPath)
            if let recordAudioButtonCell = cell as? IconButtonCell {
                self.setUpRecordAudioButtonCell(recordAudioButtonCell)
                cell = recordAudioButtonCell
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.audioPlayerCell.rawValue, for: indexPath)
            if let audioPlayerCell = cell as? AudioPlayerCell {
                audioPlayerCell.audioURL = self.audioURL
                cell = audioPlayerCell
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let photoTitleSubtitleCell = cell as? TitleSubtitleCell {
                photoTitleSubtitleCell.titleLabel.text = self.texts.takePhotoTitle
                photoTitleSubtitleCell.subtitleLabel.text = self.texts.takePhotoSubtitle
                photoTitleSubtitleCell.removeButtonDelegate = self
                photoTitleSubtitleCell.removeType = .removeImage
                cell = photoTitleSubtitleCell
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.iconButtonCell.rawValue, for: indexPath)
            if let addImageButtonCell = cell as? IconButtonCell {
                self.setUpAddImageButtonCell(addImageButtonCell)
                cell = addImageButtonCell
            }
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.photoCell.rawValue, for: indexPath)
            if let photoCell = cell as? PhotoCell {
                photoCell.imageSelected = self.selectedImage
                cell = photoCell
            }
        case 8:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.gradientButtonCell.rawValue, for: indexPath)
            if let saveMemoryButtonCell = cell as? GradientButtonCell {
                self.setUpSaveMemoryButtonCell(saveMemoryButtonCell)
                cell = saveMemoryButtonCell
            }
        default:
            print("Default")
        }
        return cell
    }
}

// MARK: Gradient Button

extension QuestionTableViewController: GradientButtonCellDelegate {
    
    // Saves detail in memory
    func gradientButtonCellAction() {
        // Prevent user from clicking on the button (and saving the memory detail) twice
        if !self.hasClickedOnSaveButton {
            self.saveDetail()
        }
        self.hasClickedOnSaveButton = true
    }
    
    /// Save memory detail on database
    func saveDetail() {
        guard let newMemoryDetail = self.getDetailFromInterface() else {
            print("Coudn't get detail from interface.")
            return
        }
        
        // Calls DAO to object to database
        DetailDAO.create(detail: newMemoryDetail) { error in
            if error == nil {
                // Return to main screen
                DispatchQueue.main.async {
                    print("Detail saved")
                    if self.isLastQuestion {
                        self.performSegue(withIdentifier: "toMemoryTitleTVC", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "nextQuestion", sender: self)
                    }
                }
            } else {
                print(error.debugDescription)
                guard let error: Error = error else {return}
                self.treatDBErrors(error: error, requestRetry: self) { (alert) in
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }

    /// Present alert warning user they cannot procceed without at least one input. Only done when save button is disabled.
    func disabledButtonAction() {
        present(AlertManager().unableToSave, animated: true, completion: nil)
    }
    
    /// Configure gradient button cell as the save button
    func setUpSaveMemoryButtonCell(_ gradientButtonCell: GradientButtonCell) {
        gradientButtonCell.title = self.texts.save
        gradientButtonCell.buttonDelegate = self
        gradientButtonCell.isEnabled = self.shouldEnableSaveButton()
    }

    // Function that enables the Gradient Button Cell
    func enableSaveButton() {
        let buttonIndexPath = IndexPath(row: 8, section: 0)
        if let gradientButtonCell = self.tableView.cellForRow(at: buttonIndexPath) as? GradientButtonCell {
            self.setUpSaveMemoryButtonCell(gradientButtonCell)
        }
    }

    /// Create Detail object from the user's input
    func getDetailFromInterface() -> Detail? {

        // Check if ID is available
        guard let memoryID = self.memoryID else {
            print("Memory ID is nil, therefore Detail can't be generated.")
            return nil
        }
        // Organize content given by user
        let category = self.navigationItem.title
        let question = self.question ?? ""
        let text = self.writtenText ?? ""
        let audio = self.audioURL
        let image = self.imageURL
        
        // Creates detail object
        let detail = Detail(memoryID: memoryID, text: text, question: question, category: category, audio: audio, image: image)
        return detail
    }
    
    /// Check if user has at least one non-empty input so we can enable the button to save this memory detail
    func shouldEnableSaveButton() -> Bool {
        
        if self.audioURL == nil &&
            self.imageURL == nil {
            if let text = self.writtenText,
               text.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            } else if self.writtenText == nil {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass memory ID information to next screen
        if let destination = segue.destination as? TitleTableViewController {
            destination.memoryID = self.memoryID
        } else if let destination = segue.destination as? QuestionTableViewController {
            destination.memoryID = self.memoryID
        }
    }

    @objc func skipQuestion() {
        self.performSegue(withIdentifier: "nextQuestion", sender: self)
    }
}

// MARK: Text View

extension QuestionTableViewController: TextViewCellDelegate {
    
    func didFinishWriting(text: String) {
        self.writtenText = text
        self.tableView.reloadData() // so the save button cell is reloaded and its button enabled/disabled if needed
    }

    func textViewContentChanged(text: String) {
        self.writtenText = text
        self.enableSaveButton()
    }
    
    /// Configure text view cell as the view for the text anwer input
    func setUpTextAnswerCell(_ textViewCell: TextViewCell) {
        textViewCell.placeholderText = self.texts.textAnswerPlaceholder
        textViewCell.textViewCellDelegate = self
        
        if let text: String = self.writtenText,
           !text.trimmingCharacters(in: .whitespaces).isEmpty {
            // If text view input is empty, display placeholder text
            textViewCell.writtenText = text
            textViewCell.shouldDisplayPlaceholderText = false
        } else {
            textViewCell.shouldDisplayPlaceholderText = true
        }
    }
}

// MARK: Icon Button

extension QuestionTableViewController: IconButtonCellDelegate {
    
    /// Configure action when clicking in an icon button
    func iconButtonCellAction(buttonType: ButtonType, sender: Any) {
        switch buttonType {
        case .addImage:
            // Open image picker
            guard let senderView = sender as? UIView else { return }
            guard let imagePicker: ImagePicker = self.imagePicker else {return}
            imagePicker.present(from: senderView)
        case .addAudio:
            // Request permission (if not given already) and open audio recording view controller
            self.recordAudioWithMicrophonePermission()
        default:
            print(buttonType)
        }
    }
    
    /// Configure button to record a new audio
    func setUpRecordAudioButtonCell(_ iconButtonCell: IconButtonCell) {
        iconButtonCell.icon.image = UIImage(named: "microphone")
        iconButtonCell.title.text = self.texts.recordAudioButtonTitle
        iconButtonCell.buttonType = .addAudio
        iconButtonCell.buttonDelegate = self
    }
    
    /// Configure button to choose a new photo
    func setUpAddImageButtonCell(_ iconButtonCell: IconButtonCell) {
        iconButtonCell.icon.image = UIImage(named: "camera")
        iconButtonCell.title.text = self.texts.takePhotoButtonTitle
        iconButtonCell.buttonType = .addImage
        iconButtonCell.buttonDelegate = self
    }
}

// MARK: Audio Recording

extension QuestionTableViewController: AudioRecordingDelegate {
    
    /// Delegate method to populate audio data
    func finishedRecording(audioURL: URL) {
        // This content will be used on saveMemory()
        self.audioURL = audioURL
        // Hide button to add photo and display audio player
        self.hiddenRows = self.hiddenRows.filter { $0 != 4 } // remove audio player cell from hiddenRows array
        self.hiddenRows.append(3) // put add audio button cell in hiddenRows array
        self.tableView.reloadData()
        self.hideRemoveButton(cellRow: 2, hide: false)
    }
    
    /// Ask for microphone usage authorization. Procceed with recording if allowed.
    public func askMicrophoneAccessAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission { allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.openAudioRecorder()
                } else {
                    print("No microphone access")
                }
            }
        }
    }
    
    /// Check microphone authorization status. Ask user to change permission in Settings if it is currently denied, and open  recorder if permission is granted.
    func recordAudioWithMicrophonePermission() {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            self.askMicrophoneAccessAuthorization()
        case .denied:
            present(AlertManager().changeMicrophonePermission, animated: true, completion: nil)
        case .granted:
            self.openAudioRecorder()
        @unknown default:
            print("Error: microphone permission is unknown")
        }
    }
    
    /// Configure and present view controller to record audio
    func openAudioRecorder() {
        guard let recordAudioScreen = (self.storyboard?.instantiateViewController(identifier: "inputAudioVC")) as? InputAudioViewController else {return}
        // Ties up this class as delegate for InputAudioVC
        recordAudioScreen.audioDelegate = self
        PresentationManager().presentAsModal(show: recordAudioScreen, over: self)
    }
}

// MARK: Image Picker

extension QuestionTableViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        // Set chosen photo as the image to be displayed and get photo URL
        guard let photo: UIImage = image else {return}
        self.imageURL = MediaManager.getURL(image: photo)
        self.selectedImage = photo
        
        // Hide button to add photo and display cell with chosen photo
        self.hiddenRows = self.hiddenRows.filter { $0 != 7 } // remove image cell from hiddenRows array
        self.hiddenRows.append(6) // put add image button cell in hiddenRows array
        self.tableView.reloadData()
        self.hideRemoveButton(cellRow: 5, hide: false)
    }
}

extension QuestionTableViewController: TitleSubtitleCellDelegate {
    
    func didTapRemove(buttonType: RemoveType) {
        
        if buttonType == .removeImage || buttonType == .removeAudio {
            // Make alert
            let alert = AlertManager().makeRemoveMediaAlert(mediaType: buttonType) {
                // Remove button action
                if buttonType == .removeAudio {
                    self.removeAudio()
                } else if buttonType == .removeImage {
                    self.removeImage()
                }
            }
            self.present(alert, animated: true)
        }
    }
    
    func removeAudio() {
        self.hideRemoveButton(cellRow: 2, hide: true)
        self.hiddenRows = self.hiddenRows.filter { $0 != 3 } // remove record button cell from hiddenRows array
        self.hiddenRows.append(4) // put audio palyer cell in hiddenRows array
        self.tableView.reloadData()
        self.audioURL = nil
    }
    
    func removeImage() {
        self.hideRemoveButton(cellRow: 5, hide: true)
        self.hiddenRows = self.hiddenRows.filter { $0 != 6 } // remove select image button cell from hiddenRows array
        self.hiddenRows.append(7) // put image cell in hiddenRows array
        self.tableView.reloadData()
        self.selectedImage = nil
        self.imageURL = nil
    }
    
    func hideRemoveButton(cellRow: Int, hide: Bool) {
        let indexPath = IndexPath(row: cellRow, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        if let titleSubtitleCell = cell as? TitleSubtitleCell {
            titleSubtitleCell.removeButtonIsHidden = hide
        }
    }
}

// MARK: Retry iCloud request

extension QuestionTableViewController: RequestRetry {
    func retryRequest() {
        if self.savingAttempts < 5 {
            self.saveDetail()
            self.savingAttempts += 1
        } else {
            self.savingAttempts = 0
            DispatchQueue.main.async {
                let alert = AlertManager().makeServiceUnavailableAlert(typeMessage: "exceeded maximum number of retry attempts")
                self.present(alert, animated: true)
            }
        }
    }
}
