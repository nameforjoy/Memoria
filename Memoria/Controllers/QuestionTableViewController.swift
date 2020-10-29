//
//  QuestionTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 28/10/20.
//

import UIKit
import AVFoundation

class QuestionTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    let titleSubtitleCellIdentifier: String = "TitleSubtitleCell"
    let subtitleCellIdentifier: String = "SubtitleCell"
    let photoCellIdentifier: String = "PhotoCell"
    let textViewIdentifier: String = "TextViewCell"
    let iconButtonCellIdentifier: String = "IconButtonCell"
    let audioPlayerCellIdentifier: String = "AudioPlayerCell"
    
    var imageURL: URL?
    var imagePicker: ImagePicker?
    var selectedImage: UIImage?
    
    var audioURL: URL?
    
    var hiddenRows: [Int] = [4,7]
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
        
        self.registerNibs()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Observers for changes in font size
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        // Image Picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeTextForAccessibility()
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // Dismisses keyboard after tapping outside keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Instantiate Nibs
    
    func registerNibs() {
        let nibTitle = UINib.init(nibName: self.titleSubtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibTitle, forCellReuseIdentifier: self.titleSubtitleCellIdentifier)
        
        let nibTextView = UINib.init(nibName: self.textViewIdentifier, bundle: nil)
        self.tableView.register(nibTextView, forCellReuseIdentifier: self.textViewIdentifier)
        
        let nibSubtitle = UINib.init(nibName: self.subtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibSubtitle, forCellReuseIdentifier: self.subtitleCellIdentifier)
        
        let nibPhoto = UINib.init(nibName: self.photoCellIdentifier, bundle: nil)
        self.tableView.register(nibPhoto, forCellReuseIdentifier: self.photoCellIdentifier)
        
        let nibIconButton = UINib.init(nibName: self.iconButtonCellIdentifier, bundle: nil)
        self.tableView.register(nibIconButton, forCellReuseIdentifier: self.iconButtonCellIdentifier)
        
        let nibAudioPlayer = UINib.init(nibName: self.audioPlayerCellIdentifier, bundle: nil)
        self.tableView.register(nibAudioPlayer, forCellReuseIdentifier: self.audioPlayerCellIdentifier)
    }
    
    // MARK: Acessibility
    
    /// Adjustments to be made if font size is changed through the dynamic type accessibility settings
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
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

    // MARK: Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.hiddenRows.contains(indexPath.row) {
            return 0.0  // collapsed
        }
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //swiftlint:disable cyclomatic_complexity
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: self.subtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = "O que aconteceu ou está acontecendo? Como você gostaria de se lembrar disso?"
                cell = cellType
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: self.textViewIdentifier, for: indexPath)
            if let cellType = cell as? TextViewCell {
                cellType.placeholderText = "Descreva sua memória aqui..."
                cell = cellType
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Que tal gravar?"
                cellType.subtitleLabel.text = "Você pode contar em áudio ou gravar algo que queira se lembrar futuramente!"
                cell = cellType
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: self.iconButtonCellIdentifier, for: indexPath)
            if let cellType = cell as? IconButtonCell {
                cellType.icon.image = UIImage(named: "microphone")
                cellType.title.text = "Gravar áudio"
                cellType.buttonType = .addAudio
                cellType.buttonDelegate = self
                cell = cellType
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: self.audioPlayerCellIdentifier, for: indexPath)
            if let cellType = cell as? AudioPlayerCell {
                cellType.audioURL = self.audioURL
                cell = cellType
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "E uma foto?"
                cellType.subtitleLabel.text = "Adicione uma foto, imagem ou desenho que esteja relacionada a essa memória."
                cell = cellType
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: self.iconButtonCellIdentifier, for: indexPath)
            if let cellType = cell as? IconButtonCell {
                cellType.icon.image = UIImage(named: "camera")
                cellType.title.text = "Adicionar foto"
                cellType.buttonType = .addImage
                cellType.buttonDelegate = self
                cell = cellType
            }
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: self.photoCellIdentifier, for: indexPath)
            if let cellType = cell as? PhotoCell {
                cellType.imageView?.image = self.selectedImage
                cell = cellType
            }
        default:
            print("Default")
        }
        return cell
    }
}

// MARK: Icon Button

extension QuestionTableViewController: IconButtonCellDelegate {
    
    func iconButtonCellAction(buttonType: ButtonType, sender: Any) {
        
        switch buttonType {
        case .addImage:
            guard let senderView = sender as? UIView else { return }
            guard let imagePicker: ImagePicker = self.imagePicker else {return}
            imagePicker.present(from: senderView)
        case .addAudio:
            self.recordAudioWithMicrophonePermission()
        default:
            print(buttonType)
        }
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
    }
    
    /// Ask for microphone usage authorization.
    /// Procceed with recording if allowed.
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
    
    /// Check microphone authorization status.
    /// Ask user to change permission in Settings if it is currently denied.
    /// Open  recorder if permission is granted.
    func recordAudioWithMicrophonePermission() {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            self.askMicrophoneAccessAuthorization()
        case .denied:
            present(Alerts().changeMicrophonePermission, animated: true, completion: nil)
        case .granted:
            self.openAudioRecorder()
        @unknown default:
            print("Error: microphone permission is unknown")
        }
    }
    
    func openAudioRecorder() {
        guard let recordAudioScreen = (self.storyboard?.instantiateViewController(identifier: "inputAudioVC")) as? InputAudioViewController else {return}
        // Ties up this class as delegate for InputAudioVC
        recordAudioScreen.audioDelegate = self
        PresentationManager().presentAsModal(show: recordAudioScreen, over: self)
    }
}

// MARK: Image Picker

///Extension For ImagePicker
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
    }
}
