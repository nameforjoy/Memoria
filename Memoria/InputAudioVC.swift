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
    var fileName =  "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupRecorder() {
        //Audio configuration
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0 ] as [String : Any]
        
        do {
            self.soundRecorder =  try AVAudioRecorder(url: self.getFileURL() as URL, settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }
        catch {
            print("Error")
        }
        
    }
    
    func getFileURL() -> NSURL {
        let path = getCacheDirectory() + fileName
        let filePath = NSURL(fileURLWithPath: path)
        
        print(filePath)
        
        return filePath
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
    }
    @IBAction func record(_ sender: Any) {
        print("record pressed")
    }
    @IBAction func play(_ sender: Any) {
        print("play pressed")
    }
    
}
