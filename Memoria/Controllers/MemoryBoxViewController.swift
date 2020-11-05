//
//  MemoryBoxViewController.swift
//  Memoria
//
//  Created by Luma Gabino Vasconcelos on 05/11/20.
//

import UIKit

class MemoryBoxViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TextPolaroidCollectionViewCell.nib(), forCellWithReuseIdentifier: TextPolaroidCollectionViewCell.identifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        let layout = UICollectionViewFlowLayout()
//        self.collectionView.collectionViewLayout = layout
    }

}

extension MemoryBoxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: TextPolaroidCollectionViewCell.identifier, for: indexPath)
        if let cellTextPolaroid = cell as? TextPolaroidCollectionViewCell {
            if indexPath.row == 4 {
                cellTextPolaroid.configure(titleText: "Aniversário Bia Aniversário Bia Aniversário Bia", timeText: "Há 3 dias")
            } else {
                cellTextPolaroid.configure(titleText: "Aniversário Bia", timeText: "Há 3 dias")
            }
        }

        return cell
    }
}

extension MemoryBoxViewController: UICollectionViewDelegate {
    
}

extension MemoryBoxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height:CGFloat = 0.0  // Fallback value
        var width:CGFloat = 0.0  // Fallback value
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            height = layout.itemSize.height
            width = layout.itemSize.width
        }

        return CGSize(width: 200, height: 300)
    }
    
}
