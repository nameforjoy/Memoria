//
//  QuestionTableViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 28/10/20.
//

import UIKit

class QuestionTableViewController: UITableViewController {
    
    let titleSubtitleCellIdentifier: String = "TitleSubtitleCell"
    let subtitleCellIdentifier: String = "SubtitleCell"
    let photoCellIdentifier: String = "PhotoCell"
    let textViewIdentifier: String = "TextViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = true
        
        self.registerNibs()
        
        // Adds tap gesture on the main view to dismiss text view keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Observers for changes in font size
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeTextForAccessibility()
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    // Dismisses keyboard after tapping outside keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func registerNibs() {
        let nibTitle = UINib.init(nibName: self.titleSubtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibTitle, forCellReuseIdentifier: self.titleSubtitleCellIdentifier)
        
        let nibTextView = UINib.init(nibName: self.textViewIdentifier, bundle: nil)
        self.tableView.register(nibTextView, forCellReuseIdentifier: self.textViewIdentifier)
        
        let nibSubtitle = UINib.init(nibName: self.subtitleCellIdentifier, bundle: nil)
        self.tableView.register(nibSubtitle, forCellReuseIdentifier: self.subtitleCellIdentifier)
        
        let nibPhoto = UINib.init(nibName: self.photoCellIdentifier, bundle: nil)
        self.tableView.register(nibPhoto, forCellReuseIdentifier: self.photoCellIdentifier)
    }
    
    // MARK: Acessibility
    
    /// Adjustments to be made if font size is changed through the dynamic type accessibility settings
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Me conta"
        } else {
            self.navigationItem.title = "Conta pra mim!"
        }
    }

    // MARK: - Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: self.subtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? SubtitleCell {
                cellType.subtitleLabel.text = "O que aconteceu ou está acontecendo? Como você gostaria de se lembrar disso?"
                cell = cellType
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: self.textViewIdentifier, for: indexPath)
            if let cellType = cell as? TextViewCell {
                cellType.placeholderText = "Descreva sua memória aqui..."
                cell = cellType
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: self.titleSubtitleCellIdentifier, for: indexPath)
            if let cellType = cell as? TitleSubtitleCell {
                cellType.titleLabel.text = "Que tal gravar?"
                cellType.subtitleLabel.text = "Você pode contar em áudio ou gravar algo que queira se lembrar futuramente!"
                cell = cellType
            }
        default:
            print("Default")
        }

        return cell
    }

}
