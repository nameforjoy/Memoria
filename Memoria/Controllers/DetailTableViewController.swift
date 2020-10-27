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
        
        let nib = UINib.init(nibName: self.photoCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: self.photoCellIdentifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.photoCellIdentifier, for: indexPath)
        if let cellType = cell as? PhotoCell {
            if (indexPath.item)%2 == 1 {
                cellType.imageSelected = UIImage(named: "photo")
            }
            return cellType
        }
        return cell
    }

}
