//
//  DetailTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 27/10/20.
//

import UIKit

class DetailTableViewController: UITableViewController {
    let titleSubtitleCellIdentifier: String = "TitleSubtitleCell"
    let subtitleCellIdentifier: String = "SubtitleCell"
    let photoCellIdentifier: String = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        let nibTitle = UINib.init(nibName: self.titleSubtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibTitle, forCellReuseIdentifier: self.titleSubtitleCellIdentifier)
        
        let nibSubtitle = UINib.init(nibName: self.subtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibSubtitle, forCellReuseIdentifier: self.subtitleCellIdentifier)
        
        let nibPhoto = UINib.init(nibName: self.photoCellIdentifier, bundle: nil)
        self.tableView.register(nibPhoto, forCellReuseIdentifier: self.photoCellIdentifier)
        
        self.navigationItem.title = "Conta pra mim!"
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.subtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                return cellType
            }
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                return cellType
            }
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                return cellType
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.photoCellIdentifier, for: indexPath)
            if let cellType = cell as? PhotoCell {
                return cellType
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.photoCellIdentifier, for: indexPath)
        if let cellType = cell as? PhotoCell {
            return cellType
        }

        return cell
    }

}
