//
//  WishlistViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { wishlist.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Obtain the cell from wishlist collection view
        guard let cellId = wishlistCellId else {
            debug("ERROR: Can't get wishlist cell id")
            return UICollectionViewCell()
        }
        let cell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        // If we are not serving for ourselves, use self as button delegate
        let delegate = collectionView == wishlistCollectionView ? nil : self
        
        // Configure an item or an outfit
        let wishlistItem = wishlist[indexPath.row]
        if let itemCell = cell as? WishlistItemCell, let item = wishlistItem.item {
            itemCell.configure(with: item, delegate: delegate)
        } else if let outfitCell = cell as? WishlistOutfitCell {
            outfitCell.configure(with: wishlistItem, delegate: delegate)
        } else {
            debug("WARNING: Can't convert wishlist item to an item or outfit cell")
        }
        return cell
    }
}
