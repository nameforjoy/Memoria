//
//  MemoryCollectionViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class MemoryCollectionViewController: UIViewController {
    
    // MARK: Attributes
    
    @IBOutlet weak var noMemoriesLabel: UILabel!
    @IBOutlet weak var addFirstMemoryButton: IconButtonView!
    @IBOutlet weak var tableView: UITableView!
    
    var memories = [Memory]()
    var didJustSaveAMemory: Bool = false

    // Temp atributes for testing data retrieve
    var userMemoryDetails: [Detail]?
    var isDataLoaded: Bool = false

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation set up
        self.setUpNavigationBar()
        self.setUpNavigationController()
        self.setUpText()
        self.addFirstMemoryButton.buttonDelegate = self
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        //TableView set up
        self.setupTableView()
        self.registerNibs()
        self.receiveData()
        self.tableView.dataSource = self
//        self.tableView.delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Present alert if a memory has just been saved
        if didJustSaveAMemory {
            self.present(Alerts().memorySaved, animated: true)
            self.didJustSaveAMemory = false
        }
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func addMemory(_ sender: Any) {
        performSegue(withIdentifier: "addMemory", sender: self)
    }

    func receiveData() {
        MemoryDAO.findAll { (memories) in
            self.memories = memories
            if self.memories.isEmpty {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
        }
    }

    // View detail if data is available
    @IBAction func clickToViewDetail(_ sender: Any) {
        if isDataLoaded {
            // Segue
            performSegue(withIdentifier: "viewDetail", sender: self)
        } else {
            print("Can't access data right now. Check if database is empty or try again later.")
        }
    }

    // MARK: Segue
    
    /// Unwind segue to get back to this view controller after saving a memory
    @IBAction func unwindToMemoryCollection(segue: UIStoryboardSegue) {}
    
    // Passes Array of Detail Objects to DetailViewController
    // Future: Passes only a single detail object as destination.currentDetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? QuestionTableViewController {
            // Set ID for new memory being created
            destination.memoryID = UUID()
        } else if let destination = segue.destination as? DetailViewController {
            destination.details = userMemoryDetails
        }
    }
    
    // MARK: Acessibility text
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Memórias"
            self.addFirstMemoryButton.title.text = "Adicionar"
            self.noMemoriesLabel.text = "Vamos adicionar sua primeira memória?"
        } else {
            self.navigationItem.title = "Caixa de memórias"
            self.addFirstMemoryButton.title.text = "Adicionar memória"
            self.noMemoriesLabel.text = "Você ainda não guardou nenhuma memória. Vamos guardar uma?"
        }
    }
    
    func setUpText() {
        self.changeTextForAccessibility()
        self.noMemoriesLabel.dynamicFont = Typography().bodyRegular
        self.addFirstMemoryButton.icon.image = UIImage(named: "plusSign")
    }
    
    // MARK: Navigation
    
    /// Navigation bar configuration
    func setUpNavigationBar() {
        guard let addButton = self.navigationItem.rightBarButtonItem else {return}
        addButton.title = "Adicionar"
        addButton.tintColor = UIColor(hexString: "7765A8")
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: Typography().calloutSemibold], for: .normal)
    }
    
    /// Configure back button of navigation flux
    func setUpNavigationController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
        // Set navigation title font
        let attributes = [NSAttributedString.Key.font: Typography().largeTitleBold]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    // MARK: TableView
    func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
    }
    
    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .memoryBoxCell)
    }
}

extension MemoryCollectionViewController: IconButtonDelegate {
    
    func iconButtonAction() {
        performSegue(withIdentifier: "addMemory", sender: self)
    }
}

extension MemoryCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

extension MemoryCollectionViewController: UITableViewDelegate {
    
}
