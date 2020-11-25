//
//  TitleTableViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit
import Network

class TitleTableViewController: UITableViewController {

    // MARK: Attributes
    
    // Network monitoring
    let monitor = NWPathMonitor()
    var savingAttempts: Int = 0
    
    // Image
    var imageURL: URL?
    var imagePicker: ImagePicker?
    var selectedImage: UIImage?
    
    // Memory
    var memory: Memory?
    var memoryID: UUID?
    var memoryDescription: String?
    var memoryTitle: String?
    
    // Interface
    var hiddenRows: [Int] = [3, 4, 5]
    var justChangedFontSize: Bool = false
    let texts = TitleTexts()
    
    // "Don't remember switch"
    var isSwitchOn: Bool = false
    
    // "Happened when" expandable cell
    var previousDateString: String = ""
    var dateString: String = ""
    
    // Date picker
    var timePassed: Int?
    var timeUnit: Calendar.Component = .day
    
    // Save button
    var hasClickedOnSaveButton:  Bool = false

    // Alert Manager
    var alertManager = AlertManager()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Alert Manager
        alertManager.delegate = self

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
        
        // Check internet connectivity
        self.checkInternetConnectivity(monitor: self.monitor)
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

    // MARK: Table view

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
            if let memoryTitleQuestionCell = cell as? SubtitleCell {
                memoryTitleQuestionCell.subtitleLabel.text = self.texts.titleQuestion
                cell = memoryTitleQuestionCell
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textFieldCell.rawValue, for: indexPath)
            if let memoryTitleInputCell = cell as? TextFieldCell {
                self.setUpMemoryTitleInputCell(memoryTitleInputCell)
                cell = memoryTitleInputCell
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.expandingCell.rawValue, for: indexPath)
            if let expandingDateCell = cell as? ExpandingCell {
                self.setUpExpandingDateCell(expandingDateCell)
                cell = expandingDateCell
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let noNeedToBePreciseCell = cell as? SubtitleCell {
                noNeedToBePreciseCell.subtitleLabel.text = self.texts.noNeedToBePrecise
                noNeedToBePreciseCell.subtitleLabel.textColor = UIColor.gray
                cell = noNeedToBePreciseCell
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.datePickerCell.rawValue, for: indexPath)
            if let datePickerCell = cell as? DatePickerCell {
                self.setUpDatePickerCell(datePickerCell)
                cell = datePickerCell
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.switchCell.rawValue, for: indexPath)
            if let dontRememberSwitchCell = cell as? SwitchCell {
                self.setUpDontRememberSwitchCell(dontRememberSwitchCell)
                cell = dontRememberSwitchCell
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let descriptionTitleCell = cell as? TitleSubtitleCell {
                descriptionTitleCell.titleLabel.text = self.texts.descriptionTitle
                descriptionTitleCell.subtitleLabel.text = self.texts.descriptionSubtitle
                cell = descriptionTitleCell
            }
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textViewCell.rawValue, for: indexPath)
            if let textViewCell = cell as? TextViewCell {
                self.setUpDescriptionTextViewCell(textViewCell)
                cell = textViewCell
            }
        case 8:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.gradientButtonCell.rawValue, for: indexPath)
            if let cellType = cell as? GradientButtonCell {
                cellType.title = self.texts.save
                cellType.buttonDelegate = self
                cellType.isEnabled = self.shouldEnableSaveButton() // only enables save button if title input is not empty
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
    
    /// Configure date picker cell
    func setUpDatePickerCell(_ datePickerCell: DatePickerCell) {
        datePickerCell.dateDelegate = self
        
        if self.justChangedFontSize {
            // Preserve displayed data after changing font size
            if let time: Int = self.timePassed {
                datePickerCell.textField.text = String(time)
                datePickerCell.timePassed = time
            } else {
                datePickerCell.textField.text = nil
                datePickerCell.timePassed = 0
            }
        }
    }
}

// MARK: Text View

extension TitleTableViewController: TextViewCellDelegate {
    func didEndEditing(text: String) {
        self.memoryDescription = text
    }

    
    func didFinishWriting(text: String) {
        self.memoryDescription = text
        self.tableView.reloadData() // so the save button cell is reloaded and its button enabled/disabled if needed
    }
    
    /// Configure description text view
    func setUpDescriptionTextViewCell(_ textViewCell: TextViewCell) {
        textViewCell.placeholderText = self.texts.descriptionTextPlaceholder
        textViewCell.textViewCellDelegate = self
        
        if let text: String = self.memoryDescription,
           !text.trimmingCharacters(in: .whitespaces).isEmpty {
            // Display placeholder if there's no text
            textViewCell.writtenText = text
            textViewCell.shouldDisplayPlaceholderText = false
        } else {
            textViewCell.shouldDisplayPlaceholderText = true
        }
    }
}

// MARK: Gradient Button

extension TitleTableViewController: GradientButtonCellDelegate {
    
    func gradientButtonCellAction() {
        if !self.hasClickedOnSaveButton {
            self.saveMemory()
        }
        self.hasClickedOnSaveButton = true
    }
    
    /// Save memory on database
    func saveMemory() {
        guard let memoryId: UUID = self.memoryID else {
            print("Memory ID not found")
            return
        }
        
        let date: Date = DateManager.getEstimatedDate(timePassed: self.timePassed, component: self.timeUnit) ?? Date()
        let memory = Memory(memoryID: memoryId, title: self.memoryTitle, description: self.memoryDescription, hasDate: !self.isSwitchOn, date: date)
        print(memory)

        MemoryDAO.create(memory: memory) { (error) in
            if error == nil {
                self.memory = memory
                // Segue
                DispatchQueue.main.async {
                    self.present(self.alertManager.memorySaved, animated: true)
                }
            } else {
                print(error.debugDescription)
                guard let error: Error = error else {return}
                self.treatDBErrors(error: error, requestRetry: self) { (alert) in
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    // Present alert warning user they cannot procceed without at least one input.
    // Only done when save button is disabled.
    func disabledButtonAction() {
        present(self.alertManager.giveTitleToSave, animated: true, completion: nil)
    }
    
    /// Check if user has input title for memory so that the save button is enabled/disabled
    func shouldEnableSaveButton() -> Bool {
        if let title = self.memoryTitle,
           title.trimmingCharacters(in: .whitespaces).isEmpty {
            return false // string of only spaces
        } else if self.memoryTitle == nil {
            return false // no string
        }
        return true
    }

}

// MARK: Expandable Cell

extension TitleTableViewController: ExpandableCellDelegate {
    
    func expandCells() {
        self.hiddenRows = [] // unhide all cells
        if self.isSwitchOn {
            self.hiddenRows.append(4) // hide date picker
        }
        self.tableView.reloadData()
    }
    
    func hideCells() {
        self.hiddenRows = [3, 4, 5] // hide all date related cells
        self.tableView.reloadData()
    }
    
    /// Configure expanding cell
    func setUpExpandingDateCell(_ expandingCell: ExpandingCell) {
        if self.dateString == self.texts.today {
            expandingCell.happenedLabel.text = self.texts.happened1 // "Happened today"/"Aconteceu hoje"
        } else {
            expandingCell.happenedLabel.text = self.texts.happened2 // "Happened XX ago/"Aconteceu há XX"
        }
        expandingCell.timeLabel.text = self.dateString // Update date text
        expandingCell.expansionDelegate = self
    }
}

// MARK: Text Field

extension TitleTableViewController: TextFieldCellDelegate {
    
    func didFinishEditing(text: String?) {
        self.memoryTitle = text
        self.tableView.reloadData() // so the placeholder text comes back when cell is loaded again if the user has erased their text
    }
    
    /// Configure title input text field cell
    func setUpMemoryTitleInputCell(_ textFieldCell: TextFieldCell) {
        textFieldCell.delegate = self
        textFieldCell.textField.placeholder = self.texts.titlePlaceholder
        if self.justChangedFontSize {
            // keeps already written text even after user changes font size
            textFieldCell.textField.text = self.memoryTitle
        }
    }
}

// MARK: Switch

extension TitleTableViewController: SwitchCellDelegate {
    
    func switchIsOn() {
        self.hiddenRows = [4] // hide date picker cell
        self.isSwitchOn = true // store switch status
        self.previousDateString = self.dateString  // store previous date
        self.dateString = self.texts.dontRememberWhen // setnewdate as "don't remember"
        self.tableView.reloadData() // so date label (expandable cell) changes and the proper cells are hidden
    }
    
    func switchIsOff() {
        self.isSwitchOn = false // store switch status
        self.hiddenRows = [] // unhide date picker cell
        self.dateString = self.previousDateString
        self.previousDateString = self.texts.dontRememberWhen
        self.tableView.reloadData() // unhide cells
    }
    
    /// Configure switch cell
    func setUpDontRememberSwitchCell(_ switchCell: SwitchCell) {
        switchCell.dontRemeberLabel.text = self.texts.dontRememberWhen
        switchCell.switchDelegate = self
        if self.justChangedFontSize {
            // preserve switch status after changing font
            switchCell.isSwitchOn = self.isSwitchOn
        }
    }
}

// MARK: Retry iCloud request

extension TitleTableViewController: RequestRetry {
    func retryRequest() {
        if self.savingAttempts < 5 {
            self.saveMemory()
            self.savingAttempts += 1
        } else {
            self.savingAttempts = 0
            DispatchQueue.main.async {
                let alert = AlertManager().makeServiceUnavailableAlert(typeMessage: "exceeded maximum number of retry attempts")
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: Saved Alert

extension TitleTableViewController: AlertManagerDelegate {
    func buttonAction() {
        self.performSegue(withIdentifier: "unwindToMemoryCollection", sender: self)
    }

}
