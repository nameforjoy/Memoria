//
//  TitleTableViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 30/10/20.
//

import UIKit

class TitleTableViewController: UITableViewController {

    var imageURL: URL?
    var imagePicker: ImagePicker?
    var selectedImage: UIImage?
    
    var memoryDescription: String?
    var memoryTitle: String?
    
    var hiddenRows: [Int] = [3, 4, 5]
    var isExpanded: Bool = false
    
    var dateString: String = "Hoje"
    var previousDate: Date?
    var date: Date? = Date() {
        didSet {
            guard let date: Date = self.date else {
                self.dateString = "Não sei"
                return
            }
            if Calendar.current.isDateInToday(date) {
                self.dateString = "Hoje"
            } else {
                self.dateString = DateManager().getTimeIntervalAsStringSinceDate(date) ?? "Não sei"
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        // self.tableView.isUserInteractionEnabled = true
        
        self.registerNibs()
        self.navigationItem.title = "Informações"
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    // Dismisses keyboard after tapping outside keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
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

    // MARK: - Table view data source

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
                cellType.subtitleLabel.text = "Qual será o título da sua memória? Como você quer resumi-la?"
                cell = cellType
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textFieldCell.rawValue, for: indexPath)
            if let cellType = cell as? TextFieldCell {
                cellType.delegate = self
                cellType.textField.text = self.memoryTitle
                cell = cellType
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.expandingCell.rawValue, for: indexPath)
            if let cellType = cell as? ExpandingCell {
                if self.dateString == "Hoje" {
                    cellType.happenedLabel.text = "Aconteceu"
                } else {
                    cellType.happenedLabel.text = "Aconteceu há"
                }
                cellType.timeLabel.text = self.dateString
                cellType.expansionDelegate = self
                cell = cellType
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.subtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = "Não se preocupe com a exatidão! Pode ser uma estimativa, tá bem?"
                cellType.subtitleLabel.textColor = UIColor.gray
                cell = cellType
            }
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.datePickerCell.rawValue, for: indexPath)
            if let cellType = cell as? DatePickerCell {
                cellType.dateDelegate = self
                cell = cellType
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.switchCell.rawValue, for: indexPath)
            if let cellType = cell as? SwitchCell {
                cellType.dontRemeberLabel.text = "Não lembro"
                cellType.switchDelegate = self
                cell = cellType
            }
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Descrição"
                cellType.subtitleLabel.text = "Faça uma breve descrição para podermos guardar na sua caixinha de memórias!"
                cell = cellType
            }
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.textViewCell.rawValue, for: indexPath)
            if let cellType = cell as? TextViewCell {
                cellType.placeholderText = "Descreva sua memória aqui..."
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
                cellType.title = "Salvar"
                cellType.buttonDelegate = self
                cellType.isEnabled = true
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
        
        let dateManager = DateManager()
        guard let date: Date = dateManager.getEstimatedDate(timePassed: timePassed, component: component) else { return }
        self.previousDate = self.date
        self.date = date
    }
}

// MARK: Text View

extension TitleTableViewController: TextViewCellDelegate {
    
    func didFinishWriting(text: String) {
        self.memoryDescription = text
        self.tableView.reloadData()
    }
}

// MARK: Gradient Button

extension TitleTableViewController: GradientButtonCellDelegate {
    
    func disabledButtonAction() {
        print("Save button is disabled")
    }
    
    func gradientButtonCellAction() {
        performSegue(withIdentifier: "unwindToMemoryCollection", sender: self)
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
        if self.date == nil {
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
    }
}

// MARK: Switch

extension TitleTableViewController: SwitchCellDelegate {
    
    func switchIsOn() {
        self.hiddenRows = [4]
        self.previousDate = self.date
        self.date = nil
        self.tableView.reloadData()
    }
    
    func switchIsOff() {
        self.hiddenRows = []
        self.date = self.previousDate
        self.previousDate = nil
        self.tableView.reloadData()
    }
}
