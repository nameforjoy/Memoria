//
//  InputAudioVC.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/10/20.
//

import UIKit
import AVFoundation

class InputAudioVC: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioPlayView: AudioPlayerView!
    
    var soundRecorder = AVAudioRecorder()

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
    
    ///Get documents diretory - permission to Microfone usage add in info.plist
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    ///Change states when recording or stop recording
    @IBAction func record(_ sender: Any) {
        if self.recordButton.titleLabel?.text == "Record" {
            soundRecorder.record()
            self.recordButton.setTitle("Stop", for: UIControl.State.normal)
        } else {
            soundRecorder.stop()
            self.recordButton.setTitle("Record", for: UIControl.State.normal)
        }
    }
    
    //    ///Enable play when finish recording
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        self.playButton.isEnabled = true
//    }
    
}
