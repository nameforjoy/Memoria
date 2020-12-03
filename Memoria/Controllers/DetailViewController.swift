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
    
    // Rows to hide (details without photo or audio)
    var hiddenRows: [Int] = []
    var detailSeparatorRows: [Int] = []
    // Number of attempts to fetch memory from iCloud
    var fetchingAttempts: Int = 0

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDetailsFromCurrentMemory()
    }

    // MARK: Instantiate Nibs

    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .titleSubtitleCell)
        self.tableView.registerNib(nibIdentifier: .subtitleCell)
        self.tableView.registerNib(nibIdentifier: .photoCell)
        self.tableView.registerNib(nibIdentifier: .audioPlayerCell)
        self.tableView.registerNib(nibIdentifier: .timePassedCell)
    }

    func retrieveDetailsFromCurrentMemory() {
        if let memoryID = selectedMemory?.memoryID {
            DetailDAO.findByMemoryID(memoryID: memoryID) { (details, error) in
                
                if error == nil {
                    print("There is \(details.count) details for this memory.")
                    self.memoryDetails = details
                    self.currentDetail = details[0]
                    
                    if !details.isEmpty {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        print("AQUIIIIIII")
                        for element in (self.memoryDetails ?? []) {
                            print(element.image)
                        }
                    }
                } else {
                    guard let error:Error = error else {return}
                    self.treatDBErrors(error: error, requestRetry: self) { (alert) in
                        self.present(alert, animated: true)
                    }
                }
            }
        }

    }
}

// MARK: Table View Delegate Methods
extension DetailViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Hide cells with indexes contained in the hiddenRows array
        if self.hiddenRows.contains(indexPath.row) {
            return 0.0  // collapsed
        } else if self.detailSeparatorRows.contains(indexPath.row) {
            return 20.0 // separate details
        }
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1 + (memoryDetails?.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        } else {
            return 4
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

        // Time Passed
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.timePassedCell.rawValue, for: indexPath)
            if let cellType = cell as? TimePassedCell {
                
                guard let memory: Memory = self.selectedMemory else {return cell}
                if let dateString = DateManager.getTimeIntervalAsStringSinceDate(memory) {
                    cellType.subtitleLabel.text = dateString
                } else {
                    self.hiddenRows.append(indexPath.row)
                }
                cell = cellType
            }
        }
        // Memory Description
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = self.selectedMemory?.description
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
                cellType.titleLabel.text = detailForSection?.question
                cellType.titleLabel.dynamicFont = Typography.title3Regular
                cellType.subtitleLabel.text = detailForSection?.text
                cellType.subtitleLabel.textColor = UIColor.gray
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
                self.hiddenRows.append(indexPath.row)
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
                self.hiddenRows.append(indexPath.row)
            }

        default:
            // self.detailSeparatorRows.append(indexPath.row)
            print("Default cell was loaded in DetailViewController")
        }

        return cell
    }
}

// MARK: Retry iCloud request

extension DetailViewController: RequestRetry {
    func retryRequest() {
        if self.fetchingAttempts < 5 {
            self.retrieveDetailsFromCurrentMemory()
            self.fetchingAttempts += 1
        } else {
            self.fetchingAttempts = 0
            DispatchQueue.main.async {
                let alert = AlertManager().makeServiceUnavailableAlert(typeMessage: "exceeded maximum number of retry attempts")
                self.present(alert, animated: true)
            }
        }
    }
}
