//
//  TitleTableViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit

class TitleTableViewController: UITableViewController {

    // MARK: Attributes
    
    // Image
    var imageURL: URL?
    var imagePicker: ImagePicker?
    var selectedImage: UIImage?
    
    // Memory
    var memoryID: UUID?
    var memoryDescription: String?
    var memoryTitle: String?
    
    // Interface
    var hiddenRows: [Int] = [3, 4, 5]
    var justChangedFontSize: Bool = false
    let texts = TitleTexts()
    
    // "Don't know switch"
    var isSwitchOn: Bool = false
    
    // "Happened when" expandable cell
    var previousDateString: String = ""
    var dateString: String = ""
    
    // Date picker
    var timePassed: Int?
    var timeUnit: Calendar.Component = .day
    
    // Save button
    var hasClickedOnSaveButton:  Bool = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view setup
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.navigationItem.hidesBackButton = true
        
        // Register xibs to be displayed in this table view
        self.registerNibs()
        
        // Initial text and accessibility setup
        self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
        self.navigationItem.title = self.texts.navigationTitle
        self.dateString = self.texts.today
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.memoryID == nil {
            print("Could not find ID for this memory")
        } else {
            print(self.memoryID ?? "ID returned nil")
        }
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // MARK: Responders
    
    /// Adjustments to be made if font size is changed through the dynamic type accessibility settings
    @objc func fontSizeChanged() {
        self.texts.isAccessibleCategory = self.traitCollection.isAccessibleCategory
        // Set flag to indicate if table view was refreshed after font size was changed
        // Needed because some information like status of switch button may be reset otherwise
        self.justChangedFontSize = true
        self.tableView.reloadData {
            self.justChangedFontSize = false
        }
    }
    
    /// Dismisses keyboard after tapping outside of it
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Instantiate Nibs
    
    /// Register xibs in this table view
    func registerNibs() {
        self.tableView.registerNib(nibIdentifier: .subtitleCell)
        self.tableView.registerNib(nibIdentifier: .textFieldCell)
        self.tableView.registerNib(nibIdentifier: .expandingCell)
        self.tableView.registerNib(nibIdentifier: .datePickerCell)
        self.tableView.registerNib(nibIdentifier: .switchCell)
        self.tableView.registerNib(nibIdentifier: .titleSubtitleCell)
        self.tableView.registerNib(nibIdentifier: .textViewCell)
        self.tableView.registerNib(nibIdentifier: .iconButtonCell)
        self.tableView.registerNib(nibIdentifier: .photoCell)
        self.tableView.registerNib(nibIdentifier: .gradientButtonCell)
    }

    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.hiddenRows.contains(indexPath.row) {
            return 0.0  // collapsed
        }
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = self.texts.titleQuestion
                cell = cellType
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textFieldCell.rawValue, for: indexPath)
            if let cellType = cell as? TextFieldCell {
                cellType.delegate = self
                cellType.textField.placeholder = self.texts.titlePlaceholder
                if self.justChangedFontSize {
                    cellType.textField.text = self.memoryTitle
                }
                cell = cellType
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.expandingCell.rawValue, for: indexPath)
            if let cellType = cell as? ExpandingCell {
                if self.dateString == self.texts.today {
                    cellType.happenedLabel.text = self.texts.happened1
                } else {
                    cellType.happenedLabel.text = self.texts.happened2
                }
                cellType.timeLabel.text = self.dateString
                cellType.expansionDelegate = self
                cell = cellType
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = self.texts.noNeedToBePrecise
                cellType.subtitleLabel.textColor = UIColor.gray
                cell = cellType
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.datePickerCell.rawValue, for: indexPath)
            if let cellType = cell as? DatePickerCell {
                
                cellType.dateDelegate = self
                
                if self.justChangedFontSize {
                    if let time: Int = self.timePassed {
                        cellType.textField.text = String(time)
                        cellType.timePassed = time
                    } else {
                        cellType.textField.text = nil
                        cellType.timePassed = 0
                    }
                }
                cell = cellType
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.switchCell.rawValue, for: indexPath)
            if let cellType = cell as? SwitchCell {
                cellType.dontRemeberLabel.text = self.texts.dontRememberWhen
                cellType.switchDelegate = self
                if self.justChangedFontSize {
                    cellType.isSwitchOn = self.isSwitchOn
                }
                cell = cellType
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = self.texts.descriptionTitle
                cellType.subtitleLabel.text = self.texts.descriptionSubtitle
                cell = cellType
            }
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textViewCell.rawValue, for: indexPath)
            if let cellType = cell as? TextViewCell {
                cellType.placeholderText = self.texts.descriptionTextPlaceholder
                cellType.textViewCellDelegate = self
                
                if let text: String = self.memoryDescription,
                   !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    cellType.writtenText = text
                    cellType.shouldDisplayPlaceholderText = false
                } else {
                    cellType.shouldDisplayPlaceholderText = true
                }
                cell = cellType
            }
        case 8:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.gradientButtonCell.rawValue, for: indexPath)
            if let cellType = cell as? GradientButtonCell {
                cellType.title = self.texts.save
                cellType.buttonDelegate = self
                cellType.isEnabled = self.shouldEnableSaveButton()
                cell = cellType
            }
        default:
            print("Default cell was loaded in TitleTalbeViewController")
        }
        
        return cell
    }
}

// MARK: Date Picker Cell

extension TitleTableViewController: DatePickerCellDelegate {
    
    func didChangeDate(timePassed: Int, component: Calendar.Component) {

        self.timePassed = timePassed
        self.timeUnit = component
        
        self.previousDateString = self.dateString
        self.dateString = DateManager.getStrinigFromTimeAndComponent(timePassed: timePassed, component: component) ?? self.texts.dontRememberWhen
        self.tableView.reloadData()
    }
}

// MARK: Text View

extension TitleTableViewController: TextViewCellDelegate {
    
    func didFinishWriting(text: String) {
        self.memoryDescription = text
        self.tableView.reloadData() // so the save button cell is reloaded and its button enabled/disabled if needed
    }
}

// MARK: Gradient Button

extension TitleTableViewController: GradientButtonCellDelegate {
    
    func gradientButtonCellAction() {
        
        if !self.hasClickedOnSaveButton {
            // Save memory
            guard let memoryId: UUID = self.memoryID else {
                print("Memory ID not found")
                return
            }
            
            let date: Date = DateManager.getEstimatedDate(timePassed: self.timePassed, component: self.timeUnit) ?? Date()
            let memory = Memory(memoryID: memoryId, title: self.memoryTitle, description: self.memoryDescription, hasDate: !self.isSwitchOn, date: date)
            print(memory)

            MemoryDAO.create(memory: memory) { (error) in
                if error == nil {
                    // Segue
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "unwindToMemoryCollection", sender: self)
                    }
                } else {
                    print(error.debugDescription)
                    // TODO: Treat error
                    // Alert "Infelizmente não conseguimos salvar sua memória"
                }
            }
        }
        
        self.hasClickedOnSaveButton = true
    }
    
    // Present alert warning user they cannot procceed without at least one input.
    // Only done when save button is disabled.
    func disabledButtonAction() {
        present(AlertManager().giveTitleToSave, animated: true, completion: nil)
    }
    
    /// Check if user has input title for memory so that the save button is enabled/disabled
    func shouldEnableSaveButton() -> Bool {
        if let title = self.memoryTitle,
           title.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else if self.memoryTitle == nil {
            return false
        }
        return true
    }
    
    // MARK: Segue
    
    // Passes needed information the the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set .didJustSaveMemory attribute to true so that the "save memory alert" show up as soon as the segue is performed
        if let destination = segue.destination as? MemoryCollectionViewController {
            destination.didJustSaveAMemory = true
        }
    }
}

// MARK: Expandable Cell

extension TitleTableViewController: ExpandableCellDelegate {
    
    func expandCells() {
        self.hiddenRows = []
        if self.isSwitchOn {
            self.hiddenRows.append(4)
        }
        self.tableView.reloadData()
    }
    
    func hideCells() {
        self.hiddenRows = [3, 4, 5]
        self.tableView.reloadData()
    }
}

// MARK: Text Field

extension TitleTableViewController: TextFieldCellDelegate {
    
    func didFinishEditing(text: String?) {
        self.memoryTitle = text
        self.tableView.reloadData() // so the placeholder text comes back when cell is loaded again if the user has erased their text
    }
}

// MARK: Switch

extension TitleTableViewController: SwitchCellDelegate {
    
    func switchIsOn() {
        self.hiddenRows = [4] // hide date picker cell
        self.isSwitchOn = true
        self.previousDateString = self.dateString
        self.dateString = self.texts.dontRememberWhen
        self.tableView.reloadData()
    }
    
    func switchIsOff() {
        self.isSwitchOn = false
        self.hiddenRows = [] // unhide date picker cell
        self.dateString = self.previousDateString
        self.previousDateString = self.texts.dontRememberWhen
        self.tableView.reloadData()
    }
}
