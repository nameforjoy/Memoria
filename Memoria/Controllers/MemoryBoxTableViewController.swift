//
//  MemoryBoxTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 06/11/20.
//

import UIKit

class MemoryBoxTableViewController: UITableViewController {

    var memories = [Memory]()
    var selectedMemory: Memory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        registerNibs()
        receiveData()
    }
    
    func receiveData() {
        MemoryDAO.findAll { (memories) in
            self.memories = memories
            self.tableView.reloadData()
        }
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
        return self.memories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.memoryBoxCell.rawValue, for: indexPath)
        if let cellType = cell as? MemoryBoxTableViewCell {
            let memory = memories[indexPath.row]
            
            cellType.titleLabel.text = memory.title
            
            let dateString = DateManager.getTimeIntervalAsStringSinceDate(memory.date)
            
            if let dateString = dateString {
                cellType.timeLabel.text = "Há " + dateString
            } else {
                cellType.timeLabel.text = "Indefinido"
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMemory = memories[indexPath.row]
        performSegue(withIdentifier: "viewMemoryDetail", sender: self)
    }

    // Passing selected memory to Detail View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.selectedMemory = self.selectedMemory
        }
    }
}
