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

    // Temporary properties for tests only
    var details: [Detail]?
    var position: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populates view with first detail
        if let details = details {
            self.populateView(detail: details[0])
            print("Loading detail #0")
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
        questionLabel.text = detail?.question
        answerLabel.text = detail?.text
        audioPlayer.audioURL = detail?.audio

        // Checks if there's an image available
        if let image = detail?.image {
            answerImageView.image = MediaManager.getUIImage(imageURL: image)
        } else {
            answerImageView.image = nil
        }
    }
}
