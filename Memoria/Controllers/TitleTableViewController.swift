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
    
    var writtenText: String?
    var hiddenRows: [Int] = [3, 4, 5, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
        
        self.registerNibs()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Image Picker
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        return 12
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.hiddenRows.contains(indexPath.row) {
            return 0.0  // collapsed
        }
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    //swiftlint:disable cyclomatic_complexity
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
                cell = cellType
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.expandingCell.rawValue, for: indexPath)
            if let cellType = cell as? ExpandingCell {
                cellType.happenedLabel.text = "Aconteceu há"
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
                cell = cellType
            }
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.switchCell.rawValue, for: indexPath)
            if let cellType = cell as? SwitchCell {
                cellType.dontRemeberLabel.text = "Não lembro"
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
                
                if let text: String = self.writtenText,
                   !text.trimmingCharacters(in: .whitespaces).isEmpty {
                    cellType.writtenText = text
                    cellType.shouldDisplayPlaceholderText = false
                } else {
                    cellType.shouldDisplayPlaceholderText = true
                }
                cell = cellType
            }
        case 8:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.titleSubtitleCell.rawValue, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Foto de capa"
                cellType.subtitleLabel.text = "Adicione uma foto, imagem ou desenho que vai ser a capa da sua memória."
                cell = cellType
            }
        case 9:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.iconButtonCell.rawValue, for: indexPath)
            if let cellType = cell as? IconButtonCell {
                cellType.icon.image = UIImage(named: "camera")
                cellType.title.text = "Adicionar foto"
                cellType.buttonType = .addImage
                cellType.buttonDelegate = self
                cell = cellType
            }
        case 10:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.photoCell.rawValue, for: indexPath)
            if let cellType = cell as? PhotoCell {
                cellType.imageSelected = self.selectedImage
                cell = cellType
            }
        case 11:
            cell = tableView.dequeueReusableCell(withIdentifier: NibIdentifier.gradientButtonCell.rawValue, for: indexPath)
            if let cellType = cell as? GradientButtonCell {
                cellType.title = "Salvar"
                cellType.buttonDelegate = self
                cellType.isEnabled = true
                cell = cellType
            }
        default:
            print("Default")
        }

        return cell
    }
}

// MARK: Text View

extension TitleTableViewController: TextViewCellDelegate {
    
    func didFinishWriting(text: String) {
        self.writtenText = text
        self.tableView.reloadData()
    }
}

// MARK: Gradient Button

extension TitleTableViewController: GradientButtonCellDelegate {
    
    func disabledButtonAction() {
        print("hkbbbobu")
    }
    
    func gradientButtonCellAction() {
        print("wiiiiii")
    }
}

// MARK: Icon Button

extension TitleTableViewController: IconButtonCellDelegate {
    
    func iconButtonCellAction(buttonType: ButtonType, sender: Any) {
        
        switch buttonType {
        case .addImage:
            guard let senderView = sender as? UIView else { return }
            guard let imagePicker: ImagePicker = self.imagePicker else {return}
            imagePicker.present(from: senderView)
        default:
            print(buttonType)
        }
    }
}

///Extension For ImagePicker
extension TitleTableViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        // Set chosen photo as the image to be displayed and get photo URL
        guard let photo: UIImage = image else {return}
        self.imageURL = MediaManager.getURL(image: photo)
        self.selectedImage = photo
        
        // Hide button to add photo and display cell with chosen photo
        self.hiddenRows = self.hiddenRows.filter { $0 != 10 } // remove image cell from hiddenRows array
        self.hiddenRows.append(9) // put add image button cell in hiddenRows array
        self.tableView.reloadData()
    }
}
