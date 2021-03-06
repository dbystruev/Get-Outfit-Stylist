//
//  ProfileViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    /// Provides the size for the header view in given profile collection view section
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - collectionViewLayout: the layout object that requests the size
    ///   - section: the section of the profile collection view to provide the header size for
    /// - Returns: header view size for the given section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: section == 0 ? 32 : 24)
    }
    
    /// Provides the size for item in given profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - collectionViewLayout: the layout object that requests the size
    ///   - indexPath: the item's index path
    /// - Returns: size for the item with index path provided
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            // Section 0 is gender - 1 item per row
            return CGSize(width: collectionView.bounds.width, height: 47)
        case 1:
            // Section 1 is brands — reuse brands view controller to answer
            return brandsViewController?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize.zero
        default:
            debug("WARNING: Unknown section \(indexPath.section)")
            return CGSize.zero
        }
    }
    
    
}
