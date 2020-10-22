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
    
    var didJustSaveAMemory: Bool = false
    var userMemoryDetails: [Detail]?
    var audios: [URL] = []
    var timesPressed = 0
    @IBOutlet weak var testAudioPlayer: AudioPlayerView!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation set up
        self.setUpNavigationBar()
        self.setUpNavigationController()
        
        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Present alert if a memory has just been saved
        if didJustSaveAMemory {
            self.present(Alerts().memorySaved, animated: true)
        }
    }
    
    deinit {
        // Take notification observers off when de-initializing the class.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @IBAction func testButton(_ sender: Any) {
    }

    // MARK: Unwind segue
    
    /// Unwind segue to get back to this view controller after saving a memory
    @IBAction func unwindToMemoryCollection(segue: UIStoryboardSegue) {}
    
    // MARK: Acessibility text
    
    @objc func fontSizeChanged(_ notification: Notification) {
        self.changeTextForAccessibility()
    }
    
    /// Change texts to a shorter version in case the accessibility settings have a large dynammic type font.
    /// Needed so no texts are cut, and the screen doesn't need too much scrolling to go through the whole content.
    func changeTextForAccessibility() {
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Memórias"
        } else {
            self.navigationItem.title = "Caixa de memórias"
        }
    }
    
    // MARK: Navigation
    
    /// Navigation bar configuration
    func setUpNavigationBar() {
        self.changeTextForAccessibility()
        guard let addButton = self.navigationItem.rightBarButtonItem else {return}
        addButton.title = "Adicionar"
    }
    
    /// Configure back button of navigation flux
    func setUpNavigationController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
    }
}
