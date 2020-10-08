//
//  InputAudioVC.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/10/20.
//

import UIKit
import AVFoundation

class InputAudioVC: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recorButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRecorder()
    }
    
    ///Initial configuration for the recorder
    func setupRecorder() {
        //Some default audio configurations
        let recordSettings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                              AVSampleRateKey: 12000,
                              AVNumberOfChannelsKey: 1,
                              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            self.soundRecorder =  try AVAudioRecorder(url: self.getFileURL(), settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error: Problemas para preparar a gravação")
        }
        
    }
    
    //Get documents diretory - permission to Microfone usage add in info.plist
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    ///Check the recordButton`s state
    @IBAction func record(_ sender: Any) {
        if self.recorButton.titleLabel?.text == "Record" {
            soundRecorder.record()
            self.recorButton.setTitle("Stop", for: UIControl.State.normal)
            self.playButton.isEnabled = false
        } else {
            soundRecorder.stop()
            self.recorButton.setTitle("Record", for: UIControl.State.normal)
            self.playButton.isEnabled = false
        }
        
    }
    
    ///Check the playButton`s state
    @IBAction func play(_ sender: Any) {
        if self.playButton.titleLabel?.text == "Play" {
            self.recorButton.isEnabled = false
            self.playButton.setTitle("Stop", for: UIControl.State.normal)
            preparePlayer()
            self.soundPlayer.play()
        } else {
            self.soundPlayer.stop()
            self.playButton.setTitle("Play", for: UIControl.State.normal)
        }
    }
    
    ///Configuration before start recording
    func preparePlayer() {
        do {
            try self.soundPlayer = AVAudioPlayer(contentsOf: getFileURL() as URL)
            self.soundPlayer.delegate = self
            self.soundPlayer.prepareToPlay()
            self.soundPlayer.volume = 1.0
        } catch {
            print("Erro: Problemas para reproduzir um áudio")
        }
    }
    
    ///Enable play when finish recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.playButton.isEnabled = true
    }
    
    ///Enable record when finish recording
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.recorButton.isEnabled = true
        self.playButton.setTitle("Play", for: UIControl.State.normal)
    }
    
}
