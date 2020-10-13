//
//  File.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 09/10/20.
//

import UIKit
import AVFoundation

class AudioPlayerViewCell: UIView, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    var showingPlayIcon = true  //if not is showing pause icon
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupSlider()
        
        //Timer for updatinng the slider when audio is playing
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    
    }
    
    func setupSlider() {
        self.slider.tintColor = .black
        
        //Set style for thumbImage
        let thumb = self.thumbImage(radius: 15)
        self.slider.setThumbImage(thumb, for: .normal)
    }
    
    @objc func updateSlider() {
        slider.value = Float(soundPlayer.currentTime)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        //Create thumb UIView with style attributes
        let thumbView = UIView()
        thumbView.backgroundColor = .white
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
    
    //Get documents diretory - permission to Microfone usage add in info.plist
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    @IBAction func playAndPause(_ sender: Any) {
        if showingPlayIcon {
            let pauseImage =  UIImage(named: "pause-icon")
            self.playButton.setImage(pauseImage, for: .normal)
            self.showingPlayIcon = false
            self.preparePlayer()
            self.soundPlayer.play()
        } else {
            let playImage =  UIImage(named: "play-icon")
            self.playButton.setImage(playImage, for: .normal)
            self.showingPlayIcon = true
            self.soundPlayer.stop()
        }
    }
    
    ///Configuration before start recording
    func preparePlayer() {
        do {
            try self.soundPlayer = AVAudioPlayer(contentsOf: getFileURL() as URL)
            self.soundPlayer.delegate = self
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.volume = 1.0
            
            //Set slider maximum value as the duration of the audio
            self.slider.maximumValue = Float(soundPlayer.duration)
        } catch {
            print("Erro: Problemas para reproduzir um áudio")
        }
    }
    
    ///Enable record when finish playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let playImage =  UIImage(named: "play-icon")
        self.playButton.setImage(playImage, for: .normal)
        self.showingPlayIcon = true
    }
    
}
