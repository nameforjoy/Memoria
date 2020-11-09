//
//  DetailViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 23/10/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var audioPlayer: AudioPlayerView!
    @IBOutlet weak var answerImageView: UIImageView!
    var currentDetail: Detail?
    var selectedMemory: Memory?
    var memoryDetails: [Detail]?

    // Temporary properties for tests only
    var details: [Detail]?
    var position: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        retrieveDetailsFromCurrentMemory()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populates view with first detail
        if let details = details {
            self.populateView(detail: details[0])
            print("Loading detail #0")
        }
    }

    func retrieveDetailsFromCurrentMemory() {
        if let memoryID = selectedMemory?.memoryID {
            DetailDAO.findByMemoryID(memoryID: memoryID) { (details) in
                self.memoryDetails = details
                //reload tableView
            }
        }
    }

    // Temporary button for tests only
    @IBAction func changeDetail(_ sender: Any) {
        guard let numberOfDetails = details?.count else { return }

        // Moves to next detail
        position += 1

        // Restarts counting when reaches last record
        if position >= numberOfDetails {
            position = 0
        }

        // Updates current detail
        currentDetail = details?[position]

        // Changing detail view content
        populateView(detail: currentDetail)
        print("Changing to detail #\(position)")
    }

    // Updates view with input detail
    func populateView(detail: Detail?) {

        // Sets category as navigation title
        self.navigationItem.title = detail?.category

        // Sets labels
        questionLabel.text = detail?.question
        answerLabel.text = detail?.text

        // Audio & Image Setup
        self.updateAudio(audio: detail?.audio)
        self.updateImage(image: detail?.image)
    }

    // Check if there's an audio available and update its view
    func updateAudio(audio: URL?) {
        if let audio = audio {
            // Populate audio player view
            audioPlayer.audioURL = audio
            // Display audio player view
            audioPlayer.isHidden = false
        } else {
            // Hides audio player view
            audioPlayer.isHidden = true
            print("Audio not found.")
        }
    }

    // Checks if there's an image available and update its view
    func updateImage(image: URL?) {
        if let image = image {
            answerImageView.image = MediaManager.getUIImage(imageURL: image)
        } else {
            print("Image not found.")
            answerImageView.image = nil
        }
    }
}
