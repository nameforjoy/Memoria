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
    var fileName =  "/audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRecorder()
    }
    
    ///Initial configuration for the recorder
    func setupRecorder() {
        //Some default audio configurations
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
        
        do {
            self.soundRecorder =  try AVAudioRecorder(url: self.getFileURL() as URL, settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print("Error: Problemas para começar a gravação")
        }
        
    }
    
    ///Add the filename to the directories path
    func getFileURL() -> NSURL {
        let path = getCacheDirectory() + fileName
        let filePath = NSURL(fileURLWithPath: path)
        return filePath
    }
    
    ///Get local developer directory
    //TODO: This makes the app crash in iPhone because don`t have access permision, so need to be changed
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
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
