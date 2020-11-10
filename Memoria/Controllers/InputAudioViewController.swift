//
//  InputAudioVC.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/10/20.
//

import UIKit
import AVFoundation
import CloudKit

protocol AudioRecordingDelegate: AnyObject {
    func finishedRecording(audioURL: URL)
}

class InputAudioViewController: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: Attributes
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var contentBackground: UIView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    weak var audioDelegate: AudioRecordingDelegate?
    var soundRecorder = AVAudioRecorder()
    var isRecording: Bool = false
    var audioURL: URL?
    
    var timer: Timer?
    var timerCount: Double = 0
    var timerManager: TimerManager?
    
    var texts = InputAudioTexts()

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRecorder()
        self.contentBackground.layer.cornerRadius = 20
        
        // Tap gesture on zone outside recorder
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAudioInputView))
        self.dismissView.addGestureRecognizer(tap)
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpText()
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // MARK: Actions
    
    ///Change states when recording or stop recording
    @IBAction func record(_ sender: Any) {
        if !self.isRecording {
            self.startRecording()
        } else {
            self.stopRecording()
            // Dismiss Audio Recorder
            self.dismiss(animated: true)
        }
    }
    
    func startRecording() {
        self.soundRecorder.record()
        self.isRecording = true
        
        // Change button image
        guard let stopImage = UIImage(named: "stopRecording") else {return}
        self.recordButton.setBackgroundImage(stopImage, for: UIControl.State.normal)
        
        // Starts timer
        let timeInterval: Double = 0.1 // seconds
        self.timerManager = TimerManager(timeInterval: timeInterval)
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func stopRecording() {
        self.soundRecorder.stop()
        self.isRecording = false
        self.timerLabel.textColor = UIColor.white
        
        // Change button image
        guard let startImage = UIImage(named: "startRecording") else {return}
        self.recordButton.setBackgroundImage(startImage, for: UIControl.State.normal)
        
        // Stop and reset timer
        self.timerCount = 0
        self.timer?.invalidate()
    }
    
    /// Dismissthis View Controller when tapping outside the content view
    @objc func dismissAudioInputView() {
        self.timer?.invalidate()
        self.dismiss(animated: true)
    }
    
    // MARK: Timer
    
    @objc func fireTimer() {
        self.timerCount += 1
        guard let time: String = self.timerManager?.getTimeString(timerCount: self.timerCount) else {return}
        self.timerLabel.text = time
        
        if time == "09:30,0" {
            self.timerLabel.textColor = UIColor.systemRed
        } else if time == "10:00,0" {
            self.stopRecording()
            
            let alertManager = AlertManager()
            alertManager.delegate = self
            self.present(alertManager.reachedAudioTimeLimit, animated: true)
        }

        if !self.isRecording {
            self.timer?.invalidate()
            self.timerLabel.text = "00:00,0"
        }
    }
    
    // MARK: Accessibility
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    /// Set up question texts in its respective labels.
    func setUpText() {
        // Set up dynamic font
        let typography = Typography()
        self.subtitleLabel.dynamicFont = typography.bodyRegular
        self.titleLabel.dynamicFont = typography.title2Bold
        self.timerLabel.dynamicFont = typography.bodyRegular.monospacedDigitFont
        
        // Starts with empty timer label
        self.timerLabel.text = ""
        self.changeTextForAccessibility()
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
        self.titleLabel.text = self.texts.recordAudioTitle
        self.subtitleLabel.text = self.texts.recordAudioSubtitle
    }
    
    // MARK: Audio Player set up
    
    ///Initial configuration for the recorder
    func setupRecorder() {
        //Some default audio configurations
        let recordSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                              AVSampleRateKey: 12000,
                              AVNumberOfChannelsKey: 1,
                              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            //Configuração do device sobre condições de gravação do áudio
            //Fazer antes do play e do record - garantia que será configurada antes
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setMode(AVAudioSession.Mode.default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            self.soundRecorder =  try AVAudioRecorder(url: self.getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error: Problemas para preparar a gravação")
        }
    }
}

// MARK: Record audio

extension InputAudioViewController: AVAudioRecorderDelegate {
    
    /// Creates Data object based on audio URL sends it to delegate method
    // TODO: Change to CKAsset
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let url = getFileURL()
        self.audioDelegate?.finishedRecording(audioURL: url)
    }
    
    ///Gets documents diretory used as temporary location for audio storage
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
}

// MARK: Alert

extension InputAudioViewController: AlertManagerDelegate {
    
    func buttonAction() {
        self.dismiss(animated: true)
    }
}
