//
//  ProfileViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    /// Get cell for the given index path in profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId: String
        switch indexPath.section {
        case 0:
            cellId = "genderCell"
        case 1:
            cellId = "brandCell"
        default:
            debug("WARNING: Unknown section \(indexPath.section)")
            return UICollectionViewCell()
        }
        
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    /// Returns the number of items in each section of profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - section: section number to return the number of items for
    /// - Returns: the number of items in given section of profile collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Section 0 is gender — 3 items
            return 3
        case 1:
            // Section 1 is brands — the number of items equal to the number of brands
            return brandedImages.count
        default:
            debug("WARNING: Unknown section \(section)")
            return 0
        }
    }
    
    /// Returns the number of sections in profile collection view: 2 (gender and brands)
    /// - Parameter collectionView: profile collection view
    /// - Returns: the number of sections in profile collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int { 2 }
}