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
    @IBOutlet weak var audioPlayView: AudioPlayerView!
    @IBOutlet weak var contentBackground: UIView!
    @IBOutlet weak var dismissView: UIView!

    weak var audioDelegate: AudioRecordingDelegate?
    var soundRecorder = AVAudioRecorder()

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRecorder()
        
        self.contentBackground.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAudioInputView))
        self.dismissView.addGestureRecognizer(tap)
    }
    
    // MARK: Actions
    
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
    
    /// Dismissthis View Controller when tapping outside the content view
    @objc func dismissAudioInputView() {
        self.dismiss(animated: true)
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
        
        // guard let audioCKAsset = try? Data(contentsOf: getFileURL()) else { return }
        self.audioDelegate?.finishedRecording(audioURL: getFileURL())
    }
    
    ///Gets documents diretory used as temporary location for audio storage
    func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording.m4a")
        return audioFilename
    }
}
