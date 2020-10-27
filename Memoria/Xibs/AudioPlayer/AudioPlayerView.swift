//
//  File.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 09/10/20.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIView, AVAudioPlayerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!
    
    var showingPlayIcon = true  // if false, then it's showing the pause icon
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    var audioURL: URL?
    private var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        loadXib(targetView: &contentView, xibName: "AudioPlayerView")
        
        self.setupSlider()
        self.setupTimer()
        self.setupLayout()
    }
    
    ///Method for load the xib view in the view controller
    func loadXib(targetView contentView: inout UIView?, xibName xib: String) {
        //load xib into content view
        contentView = Bundle.main.loadNibNamed(xib, owner: self, options: nil)![0] as? UIView
        self.addSubview(contentView!)
        
        contentView!.frame = self.bounds
        contentView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: Setups
    ///Style setup for slider
    func setupSlider() {
        self.slider.tintColor = .systemGray2
        
        //Set style for thumbImage
        let thumb = self.thumbImage(radius: 10)
        self.slider.setThumbImage(thumb, for: .normal)
    }
    
    ///Create image for thumb in slider to change layout style
    private func thumbImage(radius: CGFloat) -> UIImage {
        //Create thumb UIView with style attributes
        let thumbView = UIView()
        thumbView.backgroundColor = UIColor(named: "purple") ?? UIColor.purple
        thumbView.layer.borderWidth = 0.4
        thumbView.layer.borderColor = UIColor.darkGray.cgColor
        
        //Calculate size frame from radius
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        //Transform UIViem in UIImage
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    func setupTimer() {
        //Timer for updatinng the slider when audio is playing
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func setupLayout() {
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    // MARK: Timer updates
    @objc func updateSlider() {
        slider.value = Float(soundPlayer.currentTime)
    }
    
    @objc func updateTimerLabel() {
        let currentTime = Int(soundPlayer.currentTime)
        let duration = Int(soundPlayer.duration)
        let total = duration - currentTime

        let minutes = total/60
        let seconds = total - minutes / 60

        self.timerLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        self.timerLabel.dynamicFont = Typography().caption2Regular.monospacedDigitFont
    }
    
    // MARK: Audio play methods
    
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    ///Change state when pressed play or pause button
    @IBAction func playAndPause(_ sender: Any) {
        if showingPlayIcon {
            let pauseImage = UIImage(named: "pauseAudio")
            self.playButton.setBackgroundImage(pauseImage, for: .normal)
            
            // Prepare document URL in which tthe audio is saved
            self.showingPlayIcon = false
            if let audioURL = self.audioURL {
                preparePlayer(url: audioURL)
            } else {
                // self.preparePlayer(url: self.getFileURL())
                print("Audio URL não foi populada")
            }
            
            // Play audio
            self.soundPlayer.play()
        } else {
            let playImage =  UIImage(named: "playAudio")
            self.playButton.setBackgroundImage(playImage, for: .normal)
            self.showingPlayIcon = true
            self.soundPlayer.stop()
        }
    }
    
    ///Configuration before start recording
    func preparePlayer(url: URL) {
        do {
            // Device configuration regarding audio recording conditions
            // Should be done before play and record, to garatee it will be configured when performing those actions
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setMode(AVAudioSession.Mode.default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            
            try self.soundPlayer = AVAudioPlayer(contentsOf: url)
            self.soundPlayer.delegate = self
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.volume = 1.0
            
            // Use bottom speaker for higher volume (overrides default upper speaker)
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
               } catch _ {
                print("Unable to use bottom speaker")
            }

            // Set slider maximum value as the duration of the audio
            self.slider.maximumValue = Float(soundPlayer.duration)
        } catch {
            print("Erro: Problemas para reproduzir um áudio")
        }
    }

    ///Enable record when finish playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let playImage =  UIImage(named: "playAudio")
        self.playButton.setBackgroundImage(playImage, for: .normal)
        self.showingPlayIcon = true
    }
    
}
