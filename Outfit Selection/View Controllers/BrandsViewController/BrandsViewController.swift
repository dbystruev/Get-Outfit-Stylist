//
//  BrandsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var goButton: UIButton!
    
    // MARK: - Properties
    /// Gender selected on female male screen
    var gender = Gender.other
    
    /// Flag which changes to true when all items are loaded from the server
    var allItemsLoaded = false
    
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureLayout()
    }
    
    // MARK: - Methods
    /// Start loading items from the server
    func configureItems() {
        // Check that there are no loaded items
        allItemsLoaded = 0 < Item.all.count
        guard !allItemsLoaded else { return }
        
        // Load items if none are found
        goButton.isHidden = true
        ItemManager.shared.loadItems(filteredBy: gender) { success in
            // Update the title for go button
            self.allItemsLoaded = success == true
            let title = self.allItemsLoaded ? "Go" : "Reload"
            
            // Unhide go button when items are loaded
            DispatchQueue.main.async {
                self.goButton.isHidden = false
                self.goButton.setTitle(title, for: .normal)
            }
        }
    }
    
    /// Configure brands collection view
    func configureLayout() {
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
    }
}
