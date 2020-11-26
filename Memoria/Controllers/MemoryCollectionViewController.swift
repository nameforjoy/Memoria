//
//  MemoryCollectionViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit
import Network

class MemoryCollectionViewController: UIViewController {
    
    // MARK: Attributes
    
    @IBOutlet weak var noMemoriesLabel: UILabel!
    @IBOutlet weak var addFirstMemoryButton: IconButtonView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!

    var memories = [Memory]() {
        didSet {
            if self.memories.isEmpty {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        }
    }
    var selectedMemory: Memory?
    
    var texts = MemoryBoxTexts()
    
    // Network monitoring
    let monitor = NWPathMonitor()

    // Temp atributes for testing data retrieve
    var userMemoryDetails: [Detail]?
    var isDataLoaded: Bool = false

    // Refresh
    var refreshControl = UIRefreshControl()

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Loading data at startup
        self.updateDataFromDatabase()

        // Loading Icon Setup
        self.loadingIcon.startAnimating()
        self.loadingIcon.hidesWhenStopped = true
        self.loadingIcon.color = UIColor(hexString: "7765A8")

        // Refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController

        // Navigation set up
        self.setUpNavigationBar()
        self.setUpNavigationController()
        
        self.addFirstMemoryButton.buttonDelegate = self
        self.addFirstMemoryButton.icon.image = UIImage(named: "plusSign")
        self.noMemoriesLabel.dynamicFont = Typography.bodyRegular
        self.setUpText()
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        //TableView set up
        self.setupTableView()
        self.registerNibs()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Check internet connectivity
        self.checkInternetConnectivity(monitor: self.monitor)
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func addMemory(_ sender: Any) {
        self.addNewMemory()
    }

    // Retrieve data from server
    func updateDataFromDatabase() {

        MemoryDAO.findAll { (memories, error) in

            // Disables loading icon
            self.loadingIcon.stopAnimating()

            // Handle error
            if let error: Error = error {
                self.treatDBErrors(error: error, requestRetry: self) { (alert) in
                    // Disable loading icon
                    DispatchQueue.main.async {
                        self.loadingIcon.stopAnimating()
                        self.present(alert, animated: true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.memories = memories
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }

    // Pull to refresh action
    @objc func refresh(_ sender: AnyObject) {
         self.updateDataFromDatabase()
     }

    // MARK: Segue
    
    /// Unwind segue to get back to this view controller after saving a memory
    @IBAction func unwindToMemoryCollection(segue: UIStoryboardSegue) {
        self.updateDataFromDatabase()
    }
    
    // Passes Array of Detail Objects to DetailViewController
    // Future: Passes only a single detail object as destination.currentDetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? GradientViewController {
            // Set ID for new memory being created
            destination.memoryID = UUID()
        } else if let destination = segue.destination as? DetailViewController {
            // Sends memory to be handled by detail view controller
            destination.selectedMemory = self.selectedMemory
        }
    }
    
    // MARK: Acessibility
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    func setUpText() {
        self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
        self.navigationItem.title = self.texts.navigationTitle
        self.addFirstMemoryButton.title.text = self.texts.addMemoryButtonText
        self.noMemoriesLabel.text = self.texts.addFirstMemory
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.texts.isAccessibleCategory != self.traitCollection.isAccessibleCategory {
            self.setUpText()
        }
    }
    
    // MARK: Navigation
    
    /// Navigation bar configuration
    func setUpNavigationBar() {
        guard let addButton = self.navigationItem.rightBarButtonItem else {return}
        addButton.title = "Adicionar"
        addButton.tintColor = UIColor(hexString: "7765A8")
        addButton.setTitleTextAttributes([NSAttributedString.Key.font: Typography.calloutSemibold], for: .normal)
    }
    
    /// Configure back button of navigation flux
    func setUpNavigationController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
        
        // Set navigation title font
        let attributes = [NSAttributedString.Key.font: Typography.largeTitleBold]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    // MARK: TableView
    func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = true
        self.tableView.isUserInteractionEnabled = true
    }
    
    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .memoryBoxCell)
    }
}

// MARK: Icon button

extension MemoryCollectionViewController: IconButtonDelegate {
    
    func iconButtonAction() {
        self.addNewMemory()
    }
    
    /// Proceed to add memory screen or display warning for user to check their iCloud storage space
    func addNewMemory() {
        let shouldNotDisplayStorageAlert = UserDefaults.standard.bool(forKey: "shouldNotDisplayStorageAlert") // return false if not found
        if shouldNotDisplayStorageAlert {
            performSegue(withIdentifier: "addMemory", sender: self)
        } else {
            let alert = AlertManager().makeStorageQuotaCheckAlert {
                self.performSegue(withIdentifier: "addMemory", sender: self)
            }
            self.present(alert, animated: true)
        }
    }
}

extension MemoryCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.memoryBoxCell.rawValue, for: indexPath)

        // Disables gray default selection
        cell.selectionStyle = .none

        if let cellType = cell as? MemoryBoxTableViewCell {
            let memory = memories[indexPath.row]
            
            cellType.titleLabel.text = memory.title
            
            let dateString = DateManager.getTimeIntervalAsStringSinceDate(memory)
            cellType.timeLabel.text = dateString
        }
        return cell
    }
}

extension MemoryCollectionViewController: UITableViewDelegate {

    // Sends the tapped memory to the detail view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMemory = memories[indexPath.row]
        performSegue(withIdentifier: "viewDetail", sender: self)
    }
}

// MARK: Retry iCloud request

extension MemoryCollectionViewController: RequestRetry {
    func retryRequest() {
        self.updateDataFromDatabase()
    }
}
