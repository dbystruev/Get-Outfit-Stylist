//
//  FeedItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Static Properties
    static let segueIdentifier = "feedItemViewControllerSegue"
    
    // MARK: - Stored Properties
    /// Items to display in the item collection view
    var items: [Item] = [] {
        didSet {
            debug("items.count = \(items.count)")
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register feed item collection view cell for dequeue
        itemCollectionView.register(FeedItemCollectionViewCell.self, forCellWithReuseIdentifier: FeedItemCollectionViewCell.reuseId)
        
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
    }
}
