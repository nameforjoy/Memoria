//
//  DetailViewController.swift
//  Memoria
//
//  Created by Beatriz Viseu Linhares on 23/10/20.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedMemory: Memory?
    var currentDetail: Detail?
    var memoryDetails: [Detail]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    // Temporary property
    var details: [Detail]?
    
    // Number of attempts to fetch memory from iCloud
    var fetchingAttempts: Int = 0

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
        self.tableView.registerNib(nibIdentifier: .timePassedCell)
    }

    func retrieveDetailsFromCurrentMemory() {
        startLoadingIcon()

        if let memoryID = selectedMemory?.memoryID {
            DetailDAO.findByMemoryID(memoryID: memoryID) { (details, error) in

                self.stopLoadingIcon()

                if error == nil {
                    print("There is \(details.count) details for this memory.")
                    self.memoryDetails = details
                    self.currentDetail = details[0]
                    
                    // Uncomment if you want to test how the view looks like with multiple details
                    // This will duplicate the first detail
                    //                self.createDuplicateForTesting()
                    if !details.isEmpty {
                        self.tableView.reloadData()
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

    func startLoadingIcon() {
        // Loading Icon Setup
        self.loadingIcon.startAnimating()
        self.loadingIcon.hidesWhenStopped = true
        self.loadingIcon.color = UIColor(hexString: "7765A8")
    }

    func stopLoadingIcon() {
        // Disables loading icon
        self.loadingIcon.stopAnimating()
    }

    func createDuplicateForTesting() {
        if let detail = self.currentDetail {
            DetailDAO.create(detail: detail) { error in
                if error == nil {
                    // Return to main screen
                    DispatchQueue.main.async {
                        print("Detail saved")
                    }
                } else {
                    print(error.debugDescription)
                    // TODO: Treat error
                    // Alert "Infelizmente não conseguimos salvar sua memória"
                }
            }
        }
    }
}

// MARK: Table View Delegate Methods
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1 + (memoryDetails?.count ?? 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        } else {
            return 3 + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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
                    cellType.isHidden = true
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
                cellType.titleLabel.text = detailForSection?.category
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
