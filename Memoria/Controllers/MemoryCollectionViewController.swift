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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigationBar()
        self.setUpNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if didJustSaveAMemory {
            self.present(Alerts().memorySaved, animated: true)
        }
    }
    
    func setUpNavigationBar() {
        // Change navigation title depending on font size accessibility
        // Only changes from one to the other if you close the app an open it again
        if self.traitCollection.isAccessibleCategory {
            self.navigationItem.title = "Memórias"
        } else {
            self.navigationItem.title = "Caixa de memórias"
        }
        // Change title of the add memory button
        // Doesn't change it's size with dynamic type
        guard let addButton = self.navigationItem.rightBarButtonItem else {return}
        addButton.title = "Adicionar"
    }
    
    func setUpNavigationController() {
        // Change title of the back button for the entire navigation flux
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .plain, target: nil, action: nil)
    }
}
