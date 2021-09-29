//
//  FeedCollectionViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.reuseId,
            for: indexPath
        )
        
        guard let itemCell = cell as? FeedCollectionViewCell else {
            debug("WARNING: Can't cast \(cell) to \(FeedCollectionViewCell.self)")
            return cell
        }
        
        let kind = sections[indexPath.section]
        itemCell.configureContent(
            kind: kind,
            item: items(for: kind)[indexPath.item],
            isInteractive: true
        )
        
        itemCell.delegate = self
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInSection
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { sections.count }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FeedSectionHeaderView.reuseId,
            for: indexPath
        )
        
        guard let feedHeader = header as? FeedSectionHeaderView else {
            debug("WARNINIG: Can't cast \(header) to \(FeedSectionHeaderView.self)")
            return header
        }
        
        feedHeader.configureContent(kind: sections[indexPath.section])
        feedHeader.delegate = self
        return feedHeader
    }
}