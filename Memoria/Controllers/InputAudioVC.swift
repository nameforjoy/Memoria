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

class InputAudioVC: UIViewController, AVAudioPlayerDelegate {
    
    // MARK: Attributes
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioPlayView: AudioPlayerView!
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

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRecorder()
        
        self.contentBackground.layer.cornerRadius = 20
        self.audioPlayView.isHidden = true
        
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
            // Start recording
            self.soundRecorder.record()
            self.isRecording = true
            
            // Change button image
            guard let stopImage = UIImage(named: "stopRecording") else {return}
            self.recordButton.setBackgroundImage(stopImage, for: UIControl.State.normal)
            
            // Starts timer
            let timeInterval: Double = 0.1
            self.timerManager = TimerManager(timeInterval: timeInterval)
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            
        } else {
            // Stop recording
            self.soundRecorder.stop()
            self.isRecording = false
            self.audioPlayView.isHidden = false
            
            // Change button image
            guard let startImage = UIImage(named: "startRecording") else {return}
            self.recordButton.setBackgroundImage(startImage, for: UIControl.State.normal)
            
            // Stop and reset timer
            self.timerCount = 0
            self.timer?.invalidate()
        }
    }
    
    /// Dismissthis View Controller when tapping outside the content view
    @objc func dismissAudioInputView() {
        self.timer?.invalidate()
        self.dismiss(animated: true)
    }
    
    @objc func fireTimer() {
        self.timerCount += 1
        guard let time: String = self.timerManager?.getTimeString(timerCount: self.timerCount) else {return}
        self.timerLabel.text = time

        if !self.isRecording {
            self.timer?.invalidate()
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
        
        // Accessibility configurations
        self.changeTextForAccessibility()
        
        // Set text that will not change with accessibility
        self.writeFixedText()
    }
    
    func writeFixedText() {
        self.subtitleLabel.text = "Ao pressionar o botão, a gravação será iniciada."
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.titleLabel.text = "Podemos gravar?"
        } else {
            self.titleLabel.text = "Podemos começar a gravar?"
        }
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

extension InputAudioVC: AVAudioRecorderDelegate {
    
    /// Creates Data object based on audio URL sends it to delegate method
    // TODO: Change to CKAsset
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let url = getFileURL()
        self.audioDelegate?.finishedRecording(audioURL: url)
        //Passa a url do audio para AudioPlayerView
        self.audioPlayView.audioURL = url
    }
    
    ///Gets documents diretory used as temporary location for audio storage
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
}
