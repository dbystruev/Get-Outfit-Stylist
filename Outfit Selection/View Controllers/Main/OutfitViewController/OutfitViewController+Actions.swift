//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    /// Called when hanger bar button in navigation brat is tapped
    /// - Parameter sender: the hanger bar button which was tapped
    @IBAction func hangerBarButtonItemTapped(_ sender: Any) {
        showHangerBubble = false
        showHangerButtons.toggle()
    }
    
    /// Called when the user taps hanger bubble
    @objc func hangerBubbleTapped() {
        showHangerBubble = false
    }
    
    /// Called when one of individual hanger buttons in a scroll view is tapped
    /// - Parameter sender: the hanger button which was tapped
    @IBAction func hangerButtonTapped(_ sender: UIButton) {
        // Find the index of scroll view whose hanger button is tapped
        guard let selectedIndex = hangerButtons.firstIndex(of: sender) else { return }
        
        // Toggle (pin/unpin) selected scroll view
        scrollViews[selectedIndex].togglePinned()
        
        // Disable refresh button if all scroll views are pinned
        shuffleButton.isEnabled = !scrollViews.allPinned
        
        // Update hanger buttons opacity
        configureHangerButtons()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Set most recent like/dislike to outfits
        Wishlist.tabSuggested = .outfit
        
        // Dislike if we already liked it, or like if we didn't
        if Wishlist.contains(visibleItems) == true {
            sender.isSelected = false
            Wishlist.remove(visibleItems)
        } else {
            let controller = storyboard?.instantiateViewController(
                withIdentifier: OccasionsPopupViewController.className
            )
            guard
                let occasionsPopupViewController = controller as? OccasionsPopupViewController
            else { return }
            
            // Update properties
            occasionsPopupViewController.items = visibleItems
            occasionsPopupViewController.occasionSelected = occasionSelected
            
            // Show occasions popup
            present(occasionsPopupViewController, animated: true)
        }
    }
    
    @IBAction func occasionButtonTapped(_ sender: OccasionButton) {
        
        // Get currently selected occasion Button
        guard let currentOccasionSelected = occasionSelected else {
            debug("ERROR: No occasion button was selected")
            return
        }
        
        // Hide bubles when we started occasion selection
        hideBubbles()
        
        // Check status are loading elements
        guard !occasionItemsAreLoading else {
            debug("DEBUG Ignoring tap: occasion items are loading")
            return
        }
        
        // Get the occasion from the button
        guard var tappedOccasion = sender.occasion else { return }
        
        // If we tapped an occasion with the same title, scroll to it
        guard occasionSelected?.title != tappedOccasion.title else {
            // Make sure enough item images are loaded
            guard allowShuffle else { return }
            
            scrollTo(occasion: tappedOccasion)
            return
        }
        
        // Set status occasions elements
        occasionItemsAreLoading = true
        
        // Set selected button by the user
        occasionSelected = sender.occasion
        
        // If we tapped an occasion with different title, reload it
        Occasion.selected = tappedOccasion
        
        // Reload items and images
        let gender = Gender.current
        
        // Reload items from the server for changed occasion
        NetworkManager.shared.reloadItems(for: gender) { [weak self] success in
            if success == true {} else {
                debug("ERROR reloading items for", gender)
                
                // Set status occasions elements
                self?.occasionItemsAreLoading = false
                
                // Return occasion selected button
                tappedOccasion = currentOccasionSelected
                
                // Return occasion selected
                Occasion.selected = currentOccasionSelected
                
                // Load items occasion selected before
                ItemManager.shared.loadItems(for: Occasion.selected) { success in
                    guard success == true else {
                        debug("ERROR loading items for", gender)
                        return
                    }
                }
            }
            
            // Load images for items
            ItemManager.shared.loadImages(filteredBy: gender, cornerLimit: 1) { [weak self] current, total in
                // Wait until all images are loaded
                guard current == total else { return }
                
                // Make sure we clear occasion items loading flag in any case
                defer {
                    self?.occasionItemsAreLoading = false
                }
                
                // Check for self availability
                guard let self = self else {
                    debug("ERROR: self is not available")
                    return
                }
                
                // Scroll to newly selected occasion
                DispatchQueue.main.async {
                    self.scrollTo(occasion: tappedOccasion)
                }
            }
        }
    }
    
    /// Move to occasions view controller when left screen edge is panned
    /// - Parameter sender: left screen edge pan gesture recognizer
    @IBAction func screenEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        // Make sure the gesture has ended
        guard sender.state == .ended else { return }
        
        // Get navigation controller on top of tab bar controller
        guard let welcomeNavigationController = tabBarController?.navigationController else {
            debug("WARNING: Can't find navigation controller on top of", tabBarController)
            return
        }
        
        // Get occasions, brands, or gender view controller
        guard let popViewController = welcomeNavigationController.findViewController(
            ofType: OccasionsViewController.self
        ) ?? welcomeNavigationController.findViewController(
            ofType: BrandsViewController.self
        ) ?? welcomeNavigationController.findViewController(
            ofType: UserListViewController.self
        ) else {
            debug(
                "WARNING: Can't find \(OccasionsViewController.self),",
                "or \(BrandsViewController.self), or \(UserListViewController.self) in",
                welcomeNavigationController
            )
            return
        }
        
        // Reload occasions
        AppDelegate.updateOccasions()
        
        // Pop to occasions, brands, or gender view controller
        welcomeNavigationController.popToViewController(popViewController, animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // Get the images and check that all of them are not nil
        let imageViews = scrollViews.compactMap { $0.getImageView() }
        let images = imageViews.compactMap { $0.image }
        let items = imageViews.compactMap { $0.item }
        guard images.count == scrollViews.count && images.count == items.count else { return }
        
        // Create a view for screenshot
        shareView = ShareView.instanceFromNib()
        shareView?.configureContent(with: images, items: items)
        
        // Segue to share view controller
        performSegue(withIdentifier: "shareViewControllerSegue", sender: self)
    }
    
    /// Called when the user taps shuffle bubble
    @objc func shuffleBubbleTapped() {
        showHangerBubble = true
        showShuffleBubble = false
        showBubbles()
    }
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        debug("items loaded: \(scrollViews.itemCount) of \(Items.count)")
        
        showShuffleBubble = false
        
        // Make sure enough item images are loaded
        guard allowShuffle else { return }
        
        if let occasion = occasionSelected {
            scrollTo(occasion: occasion)
        } else {
            scrollToRandomItems()
        }
    }
}
