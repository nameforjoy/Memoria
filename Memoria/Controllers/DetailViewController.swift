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
    var memoryDetails: [Detail]?

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
                self.memoryDetails = details
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

        return 1 + (memoryDetails?.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        } else {
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()

        if indexPath.section == 0 {
            cell = self.getHeaderCell(tableView: tableView, indexPath: indexPath)
        } else {
            cell = self.getDetailCell(tableView: tableView, indexPath: indexPath)
        }

        return cell
    }

    func getHeaderCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()

        // Time Passed By
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                if let dateString = DateManager.getTimeIntervalAsStringSinceDate(selectedMemory?.date) {
                    cellType.subtitleLabel.text = dateString
                    cellType.subtitleLabel.textColor = UIColor.gray
                } else {
                    cellType.isHidden = true
                }
                cell = cellType
            }
        }
        // Memory Description
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = selectedMemory?.description
                cell = cellType
            }
        }

        return cell
    }

    func getDetailCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        let detailForSection = memoryDetails?[indexPath.section - 1]

        switch indexPath.row {

        // Detail Description
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Meus registros"
                cellType.subtitleLabel.text = detailForSection?.text
                cell = cellType
            }

        // Detail Audio
        case 1:
            if let audioURL = detailForSection?.audio {
                cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.audioPlayerCell.rawValue, for: indexPath)
                if let cellType = cell as? AudioPlayerCell {
                    cellType.audioURL = audioURL
                    cell = cellType
                }
            } else {
                cell.isHidden = true
            }

        // Detail Image
        case 2:
            if let imageURL = detailForSection?.image, let image = MediaManager.getUIImage(imageURL: imageURL) {
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
