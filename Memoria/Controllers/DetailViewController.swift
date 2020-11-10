//
//  DetailViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 23/10/20.
//

import UIKit

class DetailViewController: UITableViewController {

    var selectedMemory: Memory?
    var currentDetail: Detail?

    // Temporary property
    var details: [Detail]?

    override func viewWillAppear(_ animated: Bool) {
        retrieveDetailsFromCurrentMemory()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let selectedMemory = self.selectedMemory {
            print("ID da memória: \(selectedMemory.memoryID) ")
            self.navigationItem.title = selectedMemory.title
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

    func retrieveDetailsFromCurrentMemory() {
        if let memoryID = selectedMemory?.memoryID {
            DetailDAO.findByMemoryID(memoryID: memoryID) { (details) in
                print("There is \(details.count) details for this memory.")
                self.currentDetail = details[0]
                if !details.isEmpty {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: Table View Delegate Methods
extension DetailViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()

        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                if let dateString = DateManager.getTimeIntervalAsStringSinceDate(selectedMemory?.date) {
                    cellType.subtitleLabel.text = "Há \(dateString)"
                    cellType.subtitleLabel.textColor = UIColor.gray
                } else {
                    cellType.isHidden = true
                }
                cell = cellType
            }

        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = selectedMemory?.description
                cell = cellType
            }

        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Meus registros"
                cellType.subtitleLabel.text = currentDetail?.text
                cell = cellType
            }

        case 3:
            if let audioURL = currentDetail?.audio {
                cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.audioPlayerCell.rawValue, for: indexPath)
                if let cellType = cell as? AudioPlayerCell {
                    cellType.audioURL = audioURL
                    cell = cellType
                }
            } else {
                cell.isHidden = true
            }

        case 4:
            if let imageURL = currentDetail?.image, let image = MediaManager.getUIImage(imageURL: imageURL) {
                cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.photoCell.rawValue, for: indexPath)
                if let cellType = cell as? PhotoCell {
                    cellType.imageSelected = image
                    cell = cellType
                }
            } else {
                cell.isHidden = true
            }


        default:
            print("Default cell was loaded in DetailViewController")
        }

        return cell
    }

}
