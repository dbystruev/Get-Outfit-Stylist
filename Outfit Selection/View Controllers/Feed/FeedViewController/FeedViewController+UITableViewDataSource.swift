//
//  FeedViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cellDatas.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Choose which kind the cell will have
        let cellData = cellDatas[indexPath.row]
        
        // Obtain a feed cell
        let feedBaseCell: FeedBaseCell = {
            // Try to dequeue feed brand or item cell
            let identifier = cellData.kind == .brands ? FeedBrandCell.identifier : FeedItemCell.identifier
            let feedBaseCell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            // Check which one of the two was dequeued
            if let brandCell = feedBaseCell as? FeedBrandCell {
                brandCell.configureContent()
                return brandCell
                
            } else if let feedCell = feedBaseCell as? FeedItemCell {
                let isInteractive = tableView == feedTableView
                feedCell.configureContent(for: cellData.kind, title: cellData.title, brandNames: selectedBrandNames, items: cellData.items, isInteractive: isInteractive)
                return feedCell
            }
            
            // If none — warn and create a new feed cell
            debug("Can't dequeue \(identifier) cell")
            return cellData.kind == .brands ? FeedBrandCell() : FeedItemCell()
        }()
        
        feedBaseCell.delegate = tableView == feedTableView ? self : nil
        return feedBaseCell
    }
}
