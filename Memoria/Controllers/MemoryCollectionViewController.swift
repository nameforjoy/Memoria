//
//  MemoryCollectionViewController.swift
//  Memoria
//
//  Created by Joyce Simão Clímaco on 07/10/20.
//

import Foundation
import UIKit

class MemoryCollectionViewController: UIViewController {
    
    @IBAction func unwindToMemoryCollection(segue: UIStoryboardSegue) {}
    
    var didJustSaveAMemory: Bool = false
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let newMemory = Memory(title: "Teste", description: "O dia que eu testei aquele métodod no Xccode", date: Date())
//
//        self.dataManager.save(memory: newMemory)
        self.dataManager.retrieveAllMemories()

        self.setUpNavigationBar()
        self.setUpNavigationController()
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if didJustSaveAMemory {
            self.present(Alerts().memorySaved, animated: true)
        }
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    func setUpNavigationBar() {
        self.changeTextForAccessibility()
        // Change title of the add memory button
        // Doesn't change it's size with dynamic type
        guard let addButton = self.navigationItem.rightBarButtonItem else {return}
        addButton.title = "Adicionar"
    }
    
    func changeTextForAccessibility() {
        // Change navigation title depending on font size accessibility
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Memórias"
        } else {
            self.navigationItem.title = "Caixa de memórias"
        }
    }
    
    func setUpNavigationController() {
        // Change title of the back button for the entire navigation flux
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
    }
}
