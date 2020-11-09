//
//  DetailViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 23/10/20.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var audioPlayer: AudioPlayerView!
    @IBOutlet weak var answerImageView: UIImageView!
    var currentDetail: Detail?
    var selectedMemory: Memory?

    // Temporary properties for tests only
    var details: [Detail]?
    var allDetails: [Detail]?
//    var position: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        retrieveAllDetails()
        retrieveDetailsFromCurrentMemory()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedMemory = self.selectedMemory {
            print("ID da memória: \(selectedMemory.memoryID) ")
        }

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
        self.tableView.delegate = self

        self.registerNibs()

    }

    // MARK: Instantiate Nibs

    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .titleSubtitleCell)
        self.tableView.registerNib(nibIdentifier: .subtitleCell)
        self.tableView.registerNib(nibIdentifier: .photoCell)
        self.tableView.registerNib(nibIdentifier: .audioPlayerCell)
    }

    func retrieveAllDetails() {
        DetailDAO.findAll { (details) in
            self.allDetails = details

            for detail in details {
                print(detail.text)
                print("ID do detalhe: \(detail.memoryID).")
            }
        }
    }

    func retrieveDetailsFromCurrentMemory() {
        if let memoryID = selectedMemory?.memoryID {
            DetailDAO.findByMemoryID(memoryID: memoryID) { (details) in
                print("There is \(details.count) details for this memory.")
                self.details = details
                if !details.isEmpty {
                    self.populateView(detail: details[0])
                }
                //reload tableView
            }
        }
    }

    // Updates view with input detail
    func populateView(detail: Detail?) {

        // Sets category as navigation title
        self.navigationItem.title = selectedMemory?.title

        // Sets labels
//        questionLabel.text = detail?.question
//        answerLabel.text = detail?.text

        // Audio & Image Setup
//        self.updateAudio(audio: detail?.audio)
//        self.updateImage(image: detail?.image)
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

extension DetailViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


}
