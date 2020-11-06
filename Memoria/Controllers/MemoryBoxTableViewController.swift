//
//  MemoryBoxTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/11/20.
//

import UIKit

class MemoryBoxTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        registerNibs()
    }
    
    func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
    }
    
    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .memoryBoxCell)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.memoryBoxCell.rawValue, for: indexPath)
        return cell
    }
}
