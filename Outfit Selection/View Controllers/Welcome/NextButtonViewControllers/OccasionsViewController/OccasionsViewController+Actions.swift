//
//  OccasionsViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 11.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController {
    // MARK: - Actions
    override func nextButtonTapped(_ sender: UIButton) {
        // Start loading items
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        
        // Transition to progress
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all occasions save the selection to permanent storage
        Occasions.byTitle.keys.forEach {
            Occasions.selectWithoutSaving(title: $0, shouldSelect: isSelected)
        }
        Occasions.saveSelectedOccasions()
        
        // Reload occasions and enable / disable go button
        occasionsTableView.reloadData()
        configureGoButton()
    }
}
